# Class Mysql_backend
# Description: MySQL back end to Hiera.
# Author: Craig Dunn <craig@craigdunn.org>
# Contributor: Fabian Dammekens <fabian@dammekens.be>
#
class Hiera
    module Backend
        class Mysql_backend
            def initialize
                begin
                  require 'mysql'
                  require 'yaml'
                rescue LoadError
                  require 'rubygems'
                  require 'mysql'
                  require 'yaml'
                end

                Hiera.debug("mysql_backend initialized")
            end
            def lookup(key, scope, order_override, resolution_type)

                Hiera.debug("mysql_backend invoked lookup")
                Hiera.debug("resolution type is #{resolution_type}")

                answer = nil

                # Parse the mysql query from the config, we also pass in key
                # to extra_data so this can be interpreted into the query
                # string
                #
                queries = [ Config[:mysql][:query] ].flatten
                queries.map! { |q| Backend.parse_string(q, scope, {"key" => key}) }

                queries.each do |mysql_query|

                  results = query(mysql_query,resolution_type)

                  unless results.empty?
                    case resolution_type
                      when :array
                        raise Exception, "Hiera type mismatch: expected Array and got #{results.class}" unless results.kind_of? Array or results.kind_of? String
                        answer ||= []
                        results.each do |ritem|
                          answer << Backend.parse_answer(ritem, scope)
                        end
                      when :hash
                        raise Exception, "Hiera type mismatch: expected Hash and got #{results.class}" unless results.kind_of? Hash
                        answer ||= {}
                        answer = Backend.merge_answer(results,answer)
                      else
                       answer = Backend.parse_answer(results[0], scope)
                       break
                    end
                  end

                end
              Hiera.debug("Returning type: #{answer.class}")
              return answer
            end

            def query (sql,resolution_type)
                Hiera.debug("Executing SQL Query: #{sql}")

                case resolution_type
                  when :hash
                    data={}
                  when :array
                    data=[]
                  else
                    data=[]
                end

                mysql_host=Config[:mysql][:host]
                mysql_user=Config[:mysql][:user]
                mysql_pass=Config[:mysql][:pass]
                mysql_database=Config[:mysql][:database]

                dbh = Mysql.new(mysql_host, mysql_user, mysql_pass, mysql_database)
                dbh.reconnect = true

                res = dbh.query(sql)
                Hiera.debug("Mysql Query returned #{res.num_rows} rows")

                res.each_hash do |row|
                  variable = row["variable"]
                  value = row["value"]
                  Hiera.debug("# Found Mysql variable: " + variable + " value: " + value)
                  case resolution_type
                    when :hash
                      begin
                        newdata = YAML.load(value)
                        data.merge!(newdata)
                      rescue
                        Hiera.debug("# Mysql Query returned invalid YAML")
                        Hiera.debug("\n" + value.class)
                        Hiera.debug("\n" + value)
                      end
                    else
                      data << value
                  end
                end
              return data
            end
        end
    end
end
