{:user {:plugins [[lein-kibit "0.1.8"]
                  [com.github.liquidz/antq "2.8.1185"]]
        :aliases {"kaocha" ["with-profile" "+kaocha" "run" "-m" "kaocha.runner"]
                  "outdated-check" ["with-profile" "antq" "run" "-m" "antq.core"]
                  "outdated" ["with-profile" "antq" "run" "-m" "antq.core" "--upgrade" "--force"]}}
 :kaocha {:dependencies [[lambdaisland/kaocha "1.91.1392"]]}
 :antq {:global-vars {*warn-on-reflection* false}
        :dependencies [[com.github.liquidz/antq "RELEASE"]
                        ;; silencelogs from antq
                       ^:displace [org.slf4j/slf4j-api "RELEASE"]
                       [org.slf4j/slf4j-nop "2.0.9"]
                        ;; these are needed when running checks
                        ;; in repos with older dependencies
                       [org.clojure/tools.reader "1.4.2"]
                       [org.yaml/snakeyaml "2.2"]]}}
