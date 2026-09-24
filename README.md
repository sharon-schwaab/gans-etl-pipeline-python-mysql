🛴 Gans E-Scooter ETL Pipeline

Automated data pipeline combining city, weather and flight data using Python, REST APIs and MySQL.

Gans is an e-scooter rental startup that needs to decide where and when to position its fleet.

Two factors can strongly influence scooter demand:

how many people are arriving in a city
whether the weather is suitable for scooter use

This project builds an automated ETL pipeline that collects both signals from multiple external sources, transforms the data into a consistent format and stores it in a normalised MySQL database ready for analysis.

🔄 ETL Pipeline

The pipeline follows three main stages:

Extract
Collect city data from Wikipedia and retrieve weather and aviation data from external APIs.

Transform
Clean population values, timestamps, coordinates and nested API responses using Python and pandas.

Load
Store the transformed datasets in a relational MySQL database with primary keys, foreign keys and many-to-many relationships.

Wikipedia
    │
    ├── City information
    │
    ▼
Python ETL Pipeline
    │
    ├── OpenWeather API ──► Weather forecasts
    │
    ├── AeroDataBox API ──► Airports & flight arrivals
    │
    ▼
MySQL Database
    │
    ▼
SQL Analysis
📊 Data Sources
Source	Method	Data collected
Wikipedia	Web scraping with BeautifulSoup	City, country, coordinates, population
OpenWeather	REST API	5-day weather forecast in 3-hour intervals
AeroDataBox	REST API via RapidAPI	Nearby airports and next-day flight arrivals
Current scope

Cities: Berlin, Hamburg and Munich

The pipeline is designed to be extendable: additional cities can be added by modifying a single city list.

Coordinates scraped from Wikipedia are reused as inputs for the weather and airport APIs, meaning that new cities require minimal additional configuration.

Approximate data volume per run
3 cities
4 active airports
120 weather forecast records
~1,000 flight records
💡 What the Pipeline Enables

The main value of the project comes from combining datasets that would otherwise remain isolated.

Compare arrival activity between cities

In the analysed sample, Munich showed roughly 500 daily arrivals, compared with approximately 300 in Berlin and 180 in Hamburg.

This provides an additional signal that could help inform fleet allocation.

Combine flight and weather information

Because both datasets are stored in the same relational database, SQL can answer questions such as:

When do the most passengers arrive on days where rain is forecast?

or:

Which city has high evening arrival activity combined with favourable scooter weather?

These questions cannot be answered directly by any of the individual APIs.

Safe repeated execution

The pipeline is designed to be idempotent:

static entities are inserted only when they do not already exist
changing datasets such as forecasts and flight schedules are refreshed
repeated execution does not create duplicate static records
🗄️ Database Design

The project uses six related tables with primary keys, foreign keys and a many-to-many junction table.




The schema separates relatively static information from frequently changing data:

cities stores city information
airports stores airport information
populations stores population figures by city and year
weathers stores forecast observations
flights stores scheduled arrivals
cities_airports connects cities and airports

The cities_airports table represents a many-to-many relationship because:

one city can be served by several airports
one airport can potentially serve several cities

This structure avoids unnecessary duplication and keeps the database normalised.

🛠️ Tech Stack
Programming
Python
SQL
Python Libraries
pandas
BeautifulSoup
requests
SQLAlchemy
PyMySQL
python-dotenv
Database
MySQL 8
MySQL Workbench
Development Environment
Jupyter Notebook
Visual Studio Code
📁 Project Structure
gans-etl-pipeline-python-mysql/
│
├── gans_etl_pipeline.ipynb     # Complete ETL pipeline
│
├── sql/
│   └── create_database.sql     # MySQL schema definition
│
├── images/
│   └── schema.png              # Database diagram
│
├── requirements.txt            # Python dependencies
│
└── README.md
🚀 Getting Started
1. Clone the repository
git clone https://github.com/sharon-schwaab/gans-etl-pipeline-python-mysql.git
cd gans-etl-pipeline-python-mysql
2. Create the database

Run:

sql/create_database.sql

in MySQL Workbench.

3. Install dependencies
pip install -r requirements.txt
4. Configure API credentials

Create a .env file in the project root:

MYSQL_PASSWORD=your_password
OPENWEATHER_API_KEY=your_key
AERODATABOX_API_KEY=your_key

API credentials can be obtained from:

OpenWeather
AeroDataBox via RapidAPI

API keys and database credentials should never be committed to GitHub.

5. Run the pipeline

Open:

gans_etl_pipeline.ipynb

and run all cells.

The notebook will extract the latest available data, transform it and load the results into MySQL.

⚙️ Technical Challenges
Wikipedia request restrictions

Wikipedia rejected generic HTTP requests.

A descriptive User-Agent containing contact information was required to reliably retrieve the pages. Example request headers from older course material were no longer sufficient.

Extracting population data

Population figures inside Wikipedia infoboxes contain formatting such as:

thousands separators
references
footnote markers
nested HTML elements

A regular expression is therefore used to extract the numeric value before converting it to an integer.

AeroDataBox 12-hour request limit

The flight API limits individual schedule requests to 12-hour intervals.

Retrieving a complete day therefore requires two requests per airport.

Tomorrow's date is generated dynamically so the pipeline continues to retrieve current arrival schedules without manual date changes.

Closed airports in API results

Nearby-airport searches can still return airports that are no longer operational.

For example, Berlin Tegel Airport (TXL) may appear despite having closed in 2020.

Failed schedule requests are therefore handled gracefully and skipped rather than terminating the entire pipeline.

Timezone-aware timestamps

AeroDataBox returns timestamps containing timezone offsets.

MySQL's DATETIME datatype does not accept timezone-aware values directly, so timezone information is normalised during the transformation stage before insertion.

🔮 Future Improvements
☁️ Cloud Deployment

Move the pipeline to a cloud environment such as AWS Lambda and schedule automatic daily runs.

🌦️ Forecast History

Add a retrieved_at timestamp to weather data so successive forecasts can be stored instead of overwritten.

This would make it possible to analyse how forecasts change and evaluate forecast accuracy.

🤖 Natural-Language Data Access

Connect an LLM to the database so users could ask questions such as:

Will it rain when most evening flights arrive in Munich?

The system could translate the question into SQL and return an answer directly from the database.

📈 Demand Modelling

Combine:

flight arrivals
weather conditions
population
time of day

into a demand score that estimates expected scooter demand for each city and time period.

This could eventually turn the ETL pipeline into the data foundation for a fleet-positioning model.

👤 Author

Sharon Schwaab
Data Analytics · Python · SQL · Automation
GitHub: sharon-schwaab
LinkedIn: https://www.linkedin.com/in/sharon-schwaab/
Email: sharon.schwaab@outlook.de
