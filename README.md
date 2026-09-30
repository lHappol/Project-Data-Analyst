# NYC Taxi Trips Analysis — Power BI Dashboard

Interactive Power BI dashboard analyzing NYC taxi trips:
trip volume, time patterns, distance bins, and passenger behavior.

## Dashboard Pages
| Page | Focus |
|------|-------|
| Overview | Total trips, avg fare, passenger mix |
| Time Patterns | Hourly & daily demand trends |
| Distance & Passengers | Trips by distance bin, passengers per trip |

## Key Insights
- Short trips dominate: 1–3 mi is the most common trip distance
- Peak demand during morning & evening rush hours
- Most trips are solo passengers (1 per trip)
- Avg fare: $17.99 — longer trips are far less frequent

## Tools
- Power BI Desktop (DAX, Power Query)
- Data source: [NYC TLC Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

## Project Docs
- [Business Objective](docs/business_objective.md)
- [ER Diagram](docs/er_diagram.md)
  
## Dashboard Preview
![Overview](docs/page1-overview.png)
![Time Patterns](docs/page2-time-patterns.png)
![Distance & Passengers](docs/page3-distance.png)

## How to View

1. Download the `.pbix` file from the [`docs/`](docs/) folder (click the file → "Download raw file")
2. Open with **Power BI Desktop** (free from the Microsoft Store)

## Project Structure
- `sql/schema.sql` — table structure of cleaned yellow taxi data
- `sql/analysis.sql` — aggregate tables (passenger, payment, top zones, weekday)
- `docs/` — documentation & dashboard screenshots
