# Bravado backend test

----

You are suggested to implement a simple dockerized application that consists of two parts:

1. Rails CRUD to manage companies
2. Companies autocomplete (not necessary to use Rails, the faster the better)

----
## Requirements
1. Rails CRUD should use the latest stable Rails
2. The whole stack should be running with `docker-compose up` or `docker run ...` (1 command)
3. Rails application should be available on port 3000 (basic auth is enough)
4. Autocomplete application should be available on port 3001
5. Initial autocomplete data should be taken from [this snapshot](http://download.companieshouse.gov.uk/en_output.html)
6. Autocomplete should have simple http GET interface similar to [bravado autocomplete](https://bravado.co/autocomplete?term=goog&kind=crunchbase_company_final)
7. Autocomplete results should be **available immediately** after the container run
8. Companies database **should be updated on a background** from the snapshot every hour
9. Any changes made with CRUD should be available in the autocomplete immediately


----
## The task highlights

1. Autocomplete response time is important
2. Also important: Ruby code quality, Docker config, gems used, overall solution simplicity, system requirements
3. Database choice is not important
4. Autocomplete UI is not a strict requirement, but a simple solution built with `webpacker` would be your advantage



----------

## Архитектура

Начнем с самого интересного - автокомплит. Я ни разу до этого не реализовывал его, поэтому пришлось поресерчить немного и потратить на это время. В требованиях числится скорость и простота решения. Самым простым решением было бы хранить все данные в одном месте, например заюзать Постргю и его [полнотекстовый поиск](https://www.postgresql.org/docs/current/textsearch.html). Все, что нужно там сделать, это накинуть GIN индекс на полнотекстовое представление колонки. Я даже залил данные и подергал разные запросы, они обрабатывались за ~20-30ms. Кажется норм, но это решение очень быстро себя изживет: по мере увеличения трафа другие запросы будут тормозить автокомплит, а там критичен ответ за >100ms. Стандартное решение для автокомплита - заюзать один из поисковых движков, типа sphinx, solr, elasticsearch. Последний я и взял реализовывать. Минус такого решения в том, что данные разносятся на 2 источника и их нужно синхронизировать, то бишь наростает сложность системы в целом. Плюс эластика в том, что он заточен под эту задачу и выдает хорошую скорость, независим от других запросов, плюс масштабируется если вдруг данных станет больше. Заюзал специальное решение под автокомплит - [completion suggester](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters-completion.html). Я решил подучить Go и подумал, что микросервис автокомплита - хорошая возможность попробовать язык в деле, так как он как раз легковесен, компилируется и с дешевой конкурентностью из коробки. Вот, что получилось по бенчам:
```
✗ siege -c20 -t30S -d0.1 http://localhost:3001/\?term\=zoo%20acc

Transactions:		        4149 hits
Availability:		      100.00 %
Elapsed time:		       29.73 secs
Data transferred:	        1.02 MB
Response time:		        0.09 secs
Transaction rate:	      139.56 trans/sec
Throughput:		        0.03 MB/sec
Concurrency:		       12.84
Successful transactions:        4149
Failed transactions:	           0
Longest transaction:	        0.51
Shortest transaction:	        0.00
```
Автокомплит без какого либо тюнинга в Go, с 1 шардом в эластике держит 140 запросов в секунду при времени ответа сервера меньше 100ms. Без нагрузки время ответа ~10ms. Из снашпота взял номер компании как уникальный идентификатор, текущее название компании и 10 предыдущих названий. Предыдущие названия компаний проиндексированы автокомплитом тоже как синонимы основного названия.

Идем дальше, вторая интересная задача - импортировать каждый час только новые компании из снапшота в 4.5 миллиона строк. Проверять наличие повторений в базе - не вариант, база бы утонула в этих запросах. Если зайти в этот снапшот, то можно увидеть, что строки упорядочены. Это играет нам на руку, так как скорость нахождения разницы между двумя снапшотами будет быстрой. Идея такая, чтобы сохранять предыдущий снапшот и новый сравнивать со старым с помощью утилиты [comm](https://en.wikipedia.org/wiki/Comm). А получившийся маленький diff уже обрабатывать рельсовым таском. Чтобы не быть голосновным по скорости, ниже идет пример по скорости нахождения разницы. Я взял снапшот в 4.5 миллиона строк и добавил несколько строк в начало, середину и конец файла. Diff нашелся за 5 сек:
```
✗ time comm -1 -3 snapshots/companies_old.csv snapshots/companies.csv
"!NSPIRED INVESTMENTS LTD","SC606050",,,"26 POLMUIR ROAD",,"ABERDEEN",,"SCOTLAND","AB11 7SY","Private Limited Company","Active","United Kingdom",,"22/08/2018","31","8","22/05/2020",,"NO ACCOUNTS FILED","19/09/2019",,"0","0","0","0","41100 - Development of building projects",,,,"0","0","http://business.data.gov.uk/id/company/SC606050",,,,,,,,,,,,,,,,,,,,,"04/09/2019",
"01 DIGITAL LIMITED","05857258",,,"35 ELTON ROAD","BILLINGHAM","DURHAM",,,"TS22 5HW","Private Limited Company","Active","United Kingdom",,"26/06/2006","31","3","31/12/2018","31/03/2017","TOTAL EXEMPTION FULL","24/07/2017","26/06/2016","0","0","0","0","62020 - Information technology consultancy activities",,,,"0","0","http://business.data.gov.uk/id/company/05857258",,,,,,,,,,,,,,,,,,,,,"10/07/2019","26/06/2018"
"135 SALTRAM CRESCENT LIMITED","02009541",,,"THE POINT","37 NORTH WHARF ROAD","LONDON",,,"W2 1BD","Private Limited Company","Active","United Kingdom",,"14/04/1986","30","4","31/01/2019","30/04/2017","DORMANT","06/01/2017","09/12/2015","0","0","0","0","68209 - Other letting and operating of own or leased real estate",,,,"0","0","http://business.data.gov.uk/id/company/02009541",,,,,,,,,,,,,,,,,,,,,"08/02/2019","25/01/2018"
"AAZ PROPERTY MANAGEMENT LTD","10315079",,,"22 WYCOMBE END",,"BEACONSFIELD","BUCKINGHAMSHIRE","UNITED KINGDOM","HP9 1NB","Private Limited Company","Active","United Kingdom",,"05/08/2016","31","8","31/05/2019","31/08/2017","DORMANT","02/09/2017",,"0","0","0","0","98000 - Residents property management",,,,"0","0","http://business.data.gov.uk/id/company/10315079",,,,,,,,,,,,,,,,,,,,,"18/08/2019","04/08/2018"
"AZRA PROPERTY LIMITED","11642808",,,"6TH FLOOR, AMP HOUSE","DINGWALL ROAD","CROYDON","SURREY","UNITED KINGDOM","CR0 2LX","Private Limited Company","Active","United Kingdom",,"25/10/2018","31","10","25/07/2020",,"NO ACCOUNTS FILED","22/11/2019",,"0","0","0","0","68100 - Buying and selling of own real estate",,,,"0","0","http://business.data.gov.uk/id/company/11642808",,,,,,,,,,,,,,,,,,,,,"07/11/2019",
"UNBEATEN EVENTS LTD","11079469",,,"UNIT 10 KINGS FARM","EVERTON ROAD","HORDLE","HAMPSHIRE",,"SO41 0HD","Private Limited Company","Active","United Kingdom",,"23/11/2017","30","11","23/08/2019",,"NO ACCOUNTS FILED","21/12/2018",,"0","0","0","0","56210 - Event catering activities",,,,"0","0","http://business.data.gov.uk/id/company/11079469",,,,,,,,,,,,,,,,,,,,,"06/12/2018",

comm -1 -3 snapshots/companies_old.csv snapshots/companies.csv  5.69s user 1.69s system 84% cpu 8.703 total
```
Я не совсем понял откуда будет тащиться каждый час новый снапшот ибо тот, что указан в задании обновляется раз в месяц, поэтому я написал обновление под него, но легко можно проапгрейдить его до часового.

Остальные задачи уже не так интересны :) Все операции с компаниями(CRUD) моментально отражаются в автокомплите, реализовано через коллбеки гема `elasticsearch-model`. Авторизация обычная на HTTP. Все сервисы живут в своих контейнерах, поднимаются через `docker-compose up -d`. Контейнер Go приложения великоват для него, я знаю как его можно уменьшить до ~5mb, но уже времени не было с этим возиться.

## Установка
Предполагается, что у тебя уже стоит docker и docker-compose, тогда запускаем контейнеры:
```
docker-compose up -d
```
Создаем базу:
```
docker-compose exec rails bundle exec rake db:create db:migrate
```
Импортим данные:
```
docker-compose exec rails ./download_snapshot.sh
docker-compose exec db psql -Upostgres -d autocomplete_dev -c "copy companies(name, number, previous_name_1_company_name,  previous_name_2_company_name,  previous_name_3_company_name, previous_name_4_company_name, previous_name_5_company_name, previous_name_6_company_name, previous_name_7_company_name, previous_name_8_company_name, previous_name_9_company_name, previous_name_10_company_name) from '/snapshots/2018-11-01.csv' DELIMITER ',' csv header"
docker-compose exec rails bundle exec rake elasticsearch:import_companies
```

## Использование
Логин/пасс для авторизации - admin/admin
`localhost:3000` - рельса с CRUD
`localhost:3001?term=hui` - го с автокомплитом

Таска для обновления базы компаний:
```
docker-compose run --rm rails sh -c './download_snapshot.sh && ./snapshot_diff.sh && rake "companies:import[/snapshots/diff.csv]" && rm /snapshots/diff.csv'
```
Будет работать по прошествию месяца, как появятся 2 снапшота

## Пример работы
Создаем новые компании через CRUD: [скрин_1](https://tppr.me/boZ42)
Они сразу появляются в автокомплите: [скрин_2](https://tppr.me/rWCwJ)
