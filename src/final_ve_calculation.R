## Final Conservative Vaccine Efficacy Calculation
## Germany 2021-2024
## Assumption: Unknown deaths follow the same distribution as known deaths

cat("================================================================================\n")
cat("COVID-19 Vaccine Efficacy - Germany 2021-2024\n")
cat("Conservative Estimate Using Known Death Distribution\n")
cat("================================================================================\n\n")

# Population
unvax_pop <- 18.4  # million (22.1%)
vax_pop <- 64.9    # million (77.9%)
total_pop <- 83.3  # million

cat("POPULATION:\n")
cat(sprintf("  Unvaccinated: %.1fM (%.1f%%)\n", unvax_pop, unvax_pop/total_pop*100))
cat(sprintf("  Vaccinated:   %.1fM (%.1f%%)\n\n", vax_pop, vax_pop/total_pop*100))

# Known deaths
unvax_known <- 3000
vax_known <- 33000
unknown <- 114709

total_known <- unvax_known + vax_known
pct_unvax_known <- unvax_known / total_known * 100
pct_vax_known <- vax_known / total_known * 100

cat("DEATHS WITH KNOWN STATUS (2021-2024):\n")
cat(sprintf("  Unvaccinated: %s (%.1f%%)\n", format(unvax_known, big.mark=","), pct_unvax_known))
cat(sprintf("  Vaccinated:   %s (%.1f%%)\n", format(vax_known, big.mark=","), pct_vax_known))
cat(sprintf("  Total known:  %s\n\n", format(total_known, big.mark=",")))

cat("DEATHS WITH UNKNOWN STATUS:\n")
cat(sprintf("  Unknown:      %s (%.1f%% of all deaths)\n\n",
    format(unknown, big.mark=","),
    unknown/(unknown+total_known)*100))

# Conservative assumption: unknowns follow known distribution
cat("================================================================================\n")
cat("ASSUMPTION: Unknown deaths follow the same distribution as known deaths\n")
cat(sprintf("(%.1f%% unvaccinated, %.1f%% vaccinated)\n", pct_unvax_known, pct_vax_known))
cat("================================================================================\n\n")

unknown_unvax <- unknown * pct_unvax_known / 100
unknown_vax <- unknown * pct_vax_known / 100

cat("ESTIMATED UNKNOWN DEATHS:\n")
cat(sprintf("  Unvaccinated: %s\n", format(round(unknown_unvax), big.mark=",")))
cat(sprintf("  Vaccinated:   %s\n\n", format(round(unknown_vax), big.mark=",")))

# Total deaths
total_unvax <- unvax_known + unknown_unvax
total_vax <- vax_known + unknown_vax

cat("TOTAL ESTIMATED DEATHS (2021-2024):\n")
cat(sprintf("  Unvaccinated: %s\n", format(round(total_unvax), big.mark=",")))
cat(sprintf("  Vaccinated:   %s\n\n", format(round(total_vax), big.mark=",")))

# Death rates per 1,000 population
# (deaths / pop_in_millions = per million, then / 1000 = per 1,000)
unvax_rate <- (total_unvax / unvax_pop) / 1000
vax_rate <- (total_vax / vax_pop) / 1000

cat("DEATH RATES (per 1,000 population):\n")
cat(sprintf("  Unvaccinated: %.2f per 1,000\n", unvax_rate))
cat(sprintf("  Vaccinated:   %.2f per 1,000\n\n", vax_rate))

# Risk Ratio and Vaccine Efficacy
rr <- vax_rate / unvax_rate
ve <- (1 - rr) * 100

cat("================================================================================\n")
cat("RESULTS:\n")
cat("================================================================================\n")
cat(sprintf("  Risk Ratio (vax/unvax):  %.2f\n", rr))
cat(sprintf("  Vaccine Efficacy:        %.1f%%\n\n", ve))

if (ve < 0) {
  cat(sprintf("INTERPRETATION:\n"))
  cat(sprintf("  Vaccinated people died at %.2fx the rate of unvaccinated people.\n", rr))
  cat(sprintf("  This suggests NEGATIVE efficacy (%.1f%%).\n", ve))
} else {
  cat(sprintf("INTERPRETATION:\n"))
  cat(sprintf("  Unvaccinated people died at %.2fx the rate of vaccinated people.\n", 1/rr))
  cat(sprintf("  This suggests POSITIVE efficacy of %.1f%%.\n", ve))
}

cat("\n================================================================================\n")
cat("IMPORTANT CAVEATS:\n")
cat("================================================================================\n")
cat("1. This assumes unknown deaths have the same vaccination distribution as known\n")
cat("   deaths (8.3% unvaccinated). This is a standard statistical assumption but\n")
cat("   may not reflect reality.\n\n")
cat("2. 76% of deaths (114,709 out of 150,709) had unknown vaccination status,\n")
cat("   making any conclusion highly uncertain.\n\n")
cat("3. Confounding factors (age, comorbidities, healthcare access, etc.) are not\n")
cat("   accounted for in this crude analysis.\n\n")
cat("4. Different assumptions about the unknown deaths could yield wildly different\n")
cat("   results, ranging from strong negative to strong positive efficacy.\n")
cat("================================================================================\n")
