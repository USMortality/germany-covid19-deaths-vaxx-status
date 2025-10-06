# Germany COVID-19 Deaths by Vaccination Status Analysis

**Repository**: `germany-covid19-vaccine-efficacy-missing-data`

Analysis of German COVID-19 death data revealing critical data quality failure: **76% of deaths in 2021-2024 had unknown vaccination status**.

## Quick Start

Run the final analysis:
```bash
Rscript src/final_ve_calculation.R
```

**Result**: Vaccine efficacy of -212% (vaccinated died at 3.12x the rate), assuming unknowns follow known distribution.

## Directory Structure

```
covid_analysis/
├── src/           # R analysis scripts
├── out/           # Generated charts and reports
├── data/          # Source data
└── README.md      # This file
```

## Main Files

### Analysis Scripts (`src/`)

1. **`final_ve_calculation.R`** ⭐ **Main analysis**
   - Conservative efficacy calculation using standard statistical assumption
   - Assumes unknowns follow known distribution (8.3% unvax)
   - Clear output with all caveats
   - **Result**: -212% efficacy (vaccinated died at 3.12x the rate)

2. **`covid_ve_calc.R`** - Sensitivity analysis
   - Shows vaccine efficacy across all possible unknown distributions (0-100% unvax)
   - Demonstrates extreme sensitivity to assumptions
   - Generates: `covid_ve_by_unknown_pct.png`

3. **`covid_deaths_grouped.R`** - Visualization
   - Deaths by period (2020 pre-vaccine vs 2021-2024 vaccine era)
   - Broken down by vaccination status
   - Generates: `covid_deaths_grouped.png`

### Outputs (`out/`)

1. **`covid_vaccine_analysis_final.md`** ⭐ **Final report**
   - Complete analysis with source citations (BMG via AfD inquiry, NZZ)
   - Conservative estimate: -212% efficacy (vaccinated died at 3.12x rate)
   - Sensitivity analysis showing range from -212% to +92% efficacy
   - Full caveats and limitations

2. **Charts:**
   - `covid_deaths_grouped.png` - Deaths by period (2020 vs 2021-2024) and vaccination status
   - `covid_ve_by_unknown_pct.png` - Efficacy sensitivity curve (0-100% unknown distributions)

### Data (`data/`)

- `covid_deaths_daily.csv` - RKI daily death data (2020-2025)
  - Source: [Robert Koch Institut GitHub](https://github.com/robert-koch-institut/COVID-19-Todesfaelle_in_Deutschland)

## Key Findings

### Conservative Estimate (Unknowns = Knowns Distribution)

- **Vaccine Efficacy: -212%**
- Vaccinated died at **3.12x** the rate of unvaccinated
- Death rates (per 1,000):
  - Unvaccinated: 0.68
  - Vaccinated: 2.13

### Why This Is Uncertain

**76% of deaths (114,709 out of 150,709) had unknown vaccination status.**

Different assumptions yield wildly different results:
- **8.3% unknowns unvax** (known dist.): -212% efficacy
- **22.1% unknowns unvax** (population): -22% efficacy
- **50% unknowns unvax** (agnostic): +58% efficacy
- **100% unknowns unvax** (extreme): +92% efficacy

## Data Source

**German Federal Ministry of Health (Bundesministerium für Gesundheit, BMG)**
- Obtained via AfD parliamentary inquiry (Bundestags-Anfrage)
- Reported by: [NZZ](https://www.nzz.ch/international/impfstatus-bei-den-meisten-corona-toten-ungeklaert-wie-deutschland-bei-pandemie-daten-versagte-ld.1905321)

### Death Counts (2020-2024)

- **Total**: 187,000
- **Unvaccinated**: 39,000 (mostly in 2020 pre-vaccine)
- **Vaccinated**: 33,000
- **Unknown**: 115,000

### 2021-2024 Breakdown

- **Unvaccinated**: 3,000 (2.0%)
- **Vaccinated**: 33,000 (21.9%)
- **Unknown**: 114,709 (76.1%) ❗

### Population (April 2023)

- **Unvaccinated**: 18.4M (22.1%)
- **Vaccinated**: 64.9M (77.9%)

## Requirements

- R (tested with 4.x)
- Libraries: `ggplot2`, `dplyr`, `lubridate`

Install dependencies:
```R
install.packages(c("ggplot2", "dplyr", "lubridate"))
```

## Reproducing the Analysis

1. Run main analysis:
```bash
Rscript src/final_ve_calculation.R
```

2. Generate sensitivity chart:
```bash
Rscript src/covid_ve_calc.R
```

3. Generate grouped deaths chart:
```bash
Rscript src/covid_deaths_grouped.R
```

## Important Caveats

1. **Missing data**: 76% unknown status makes conclusions highly uncertain
2. **No confounding adjustment**: Age, comorbidities, timing not accounted for
3. **Crude analysis**: This is NOT a proper epidemiological study
4. **Standard assumption**: Assumes unknowns ~ knowns, which may not hold

## What Data Would Be Needed for Proper Analysis?

The current analysis is severely limited by data quality and granularity. A proper vaccine efficacy study would require:

### 1. Complete Vaccination Status ⭐ **CRITICAL**
- **Current**: 76% unknown status
- **Needed**: <5% unknown (ideally 0%)
- **Why**: Can't calculate efficacy when 3/4 of deaths are missing the primary variable

### 2. Temporal Granularity
- **Current**: Annual aggregates only
- **Needed**: **Monthly** (minimum) or **weekly** (ideal) data on:
  - Deaths by vaccination status
  - Vaccination coverage rates
- **Why**:
  - Vaccination rates changed dramatically over time (0% → 78%)
  - Dominant variants changed (Alpha → Delta → Omicron)
  - Healthcare capacity varied
  - Can match deaths to contemporaneous vaccination rates

### 3. Age Stratification ⭐ **CRITICAL**
- **Current**: No age breakdown
- **Needed**: Deaths by vaccination status in age groups (e.g., 0-17, 18-29, 30-39, 40-49, 50-59, 60-69, 70-79, 80+)
- **Why**:
  - Age is the strongest predictor of COVID mortality
  - Vaccination rates varied by age (elderly vaccinated first)
  - Without age adjustment, results are meaningless

### 4. Vaccination Details
- **Current**: Binary (vaccinated yes/no)
- **Needed**:
  - **Number of doses** (0, 1, 2, 3, 4+)
  - **Time since last dose** (<1 month, 1-3 months, 3-6 months, 6+ months)
  - **Vaccine type** (BioNTech/Pfizer, Moderna, AstraZeneca, J&J)
  - **Date of last vaccination**
- **Why**: Efficacy wanes over time and varies by dose count

### 5. Health Status Indicators
- **Current**: None
- **Needed**:
  - **Comorbidities** (diabetes, cardiovascular disease, obesity, immunocompromised, etc.)
  - **Prior COVID infection** status
  - **Hospitalization data** (ICU admission, ventilation)
- **Why**: Adjusting for confounders (healthier people more likely to be vaccinated)

### 6. Variant Information
- **Current**: None
- **Needed**: Monthly dominant variant data matched to death periods
- **Why**: Virulence varied dramatically (Alpha vs Omicron)

### 7. Geographic Granularity
- **Current**: National aggregate
- **Needed**: State (Bundesland) or district (Landkreis) level
- **Why**:
  - Regional vaccination campaigns
  - Healthcare capacity differences
  - Regional variant waves

### 8. Data Format

**Ideal**: De-identified **individual-level records** with:
```csv
death_id, death_date, age, sex, bundesland, vaccination_status, doses, last_vax_date,
vaccine_type, comorbidities, prior_infection, hospitalized, icu, variant_period
```

**Minimum acceptable**: **Monthly aggregated tables** with:
```csv
month, age_group, vax_status, doses, deaths, population_denominator
```

### 9. Denominator Data
- **Current**: Overall population by vaccination status (one value for 2021-2024)
- **Needed**: **Monthly person-time at risk** by:
  - Age group
  - Vaccination status
  - Doses received
- **Why**: Population denominators change over time as people get vaccinated

### Example of Proper Data Structure

**Monthly Deaths by Age and Vaccination Status:**
| Year-Month | Age Group | Unvaccinated Deaths | 1 Dose Deaths | 2 Doses Deaths | 3+ Doses Deaths |
|------------|-----------|---------------------|---------------|----------------|-----------------|
| 2021-01    | 80+       | 2,450              | 50            | 0              | 0               |
| 2021-02    | 80+       | 2,100              | 350           | 5              | 0               |
| ...        | ...       | ...                 | ...           | ...            | ...             |

**Monthly Population by Age and Vaccination Status:**
| Year-Month | Age Group | Unvaccinated Pop | 1 Dose Pop | 2 Doses Pop | 3+ Doses Pop |
|------------|-----------|------------------|------------|-------------|--------------|
| 2021-01    | 80+       | 5,800,000        | 50,000     | 0           | 0            |
| 2021-02    | 80+       | 4,900,000        | 200,000    | 700,000     | 0            |
| ...        | ...       | ...              | ...        | ...         | ...          |

### Summary: Data Requirements

| Requirement | Priority | Current Status | Needed Resolution |
|-------------|----------|----------------|-------------------|
| Complete vax status | 🔴 Critical | 24% complete | >95% complete |
| Age stratification | 🔴 Critical | None | 10-year groups minimum |
| Temporal granularity | 🟡 High | Annual | Monthly minimum |
| Vaccination details | 🟡 High | Binary | Doses + timing |
| Comorbidities | 🟡 High | None | Major conditions |
| Prior infection | 🟢 Medium | None | Yes/No |
| Variant data | 🟢 Medium | None | Monthly dominant variant |
| Geographic detail | 🟢 Low | National | State level |

**Bottom line**: Without complete vaccination status and age stratification, **no reliable efficacy estimate is possible**, regardless of analytical sophistication.

## Conclusion

The most defensible statistical assumption (unknowns follow knowns) suggests negative efficacy, but the massive data gap (76% unknown) means **definitive conclusions are impossible**.

The real finding: **Germany made public health policy with critically incomplete data** - 3 out of 4 COVID deaths had unknown vaccination status.

---

## License & Attribution

**Analysis by**: [@USMortality](https://twitter.com/USMortality)
**Tools**: Claude Sonnet 4.5 (Anthropic AI)

**License**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

You are free to share and adapt this work with attribution.

**Citation**:
```
@USMortality (2025). Germany COVID-19 Vaccine Efficacy Analysis: Missing Data Problem.
Analysis conducted with Claude Sonnet 4.5.
Source: German Federal Ministry of Health via AfD parliamentary inquiry, reported by NZZ.
https://www.nzz.ch/international/impfstatus-bei-den-meisten-corona-toten-ungeklaert-wie-deutschland-bei-pandemie-daten-versagte-ld.1905321
```
