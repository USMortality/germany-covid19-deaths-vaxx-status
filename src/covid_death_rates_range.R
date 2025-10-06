library(ggplot2)

# Population data
unvax_pop <- 18.4  # million
vax_pop <- 64.9    # million

# Known deaths 2021-2024
unvax_known <- 3000
vax_known <- 33000
unknown <- 114709

# Calculate death rates for different scenarios
calc_rates <- function(pct_unknown_unvax) {
  unknown_unvax <- unknown * pct_unknown_unvax / 100
  total_unvax <- unvax_known + unknown_unvax
  total_vax <- vax_known + (unknown - unknown_unvax)

  unvax_rate <- (total_unvax / unvax_pop) / 1000  # per 1,000
  vax_rate <- (total_vax / vax_pop) / 1000

  c(unvax_rate, vax_rate)
}

# Scenarios
# All unknowns are unvaccinated (gives highest unvax rate, lowest vax rate)
all_unvax <- calc_rates(100)
# Known distribution: 8.3% unknowns unvax
known_dist <- calc_rates(8.3)
# All unknowns are vaccinated (gives lowest unvax rate, highest vax rate)
all_vax <- calc_rates(0)

# Create data with correct bounds
# For unvaccinated: lower = all_vax[1], upper = all_unvax[1]
# For vaccinated: lower = all_unvax[2], upper = all_vax[2]
data <- data.frame(
  group = c("Unvaccinated", "Vaccinated"),
  rate = c(known_dist[1], known_dist[2]),
  lower = c(all_vax[1], all_unvax[2]),  # Fixed: correct lower bounds
  upper = c(all_unvax[1], all_vax[2])   # Fixed: correct upper bounds
)

# Create plot
p <- ggplot(data, aes(x = group, y = rate, fill = group)) +
  geom_bar(stat = "identity", width = 0.6, alpha = 0.8, color = "black", linewidth = 1) +
  geom_errorbar(aes(ymin = lower, ymax = upper),
                width = 0.25, linewidth = 1.5, color = "black") +
  geom_text(aes(label = sprintf("%.2f", rate)),
            vjust = -4.5, size = 6, fontface = "bold") +
  geom_text(aes(y = upper, label = sprintf("Range: %.2f - %.2f", lower, upper)),
            vjust = -0.8, size = 4, fontface = "italic") +
  scale_fill_manual(values = c("Unvaccinated" = "#e74c3c", "Vaccinated" = "#27ae60")) +
  labs(
    title = "COVID-19 Death Rates in Germany (2021-2024)",
    subtitle = sprintf("Based on %s known + %s unknown deaths | Conservative estimate assumes unknowns = knowns (8.3%% unvax)",
                      format(unvax_known + vax_known, big.mark = ","),
                      format(unknown, big.mark = ",")),
    y = "Deaths per 1,000 Population",
    x = "",
    caption = "Source: German Federal Ministry of Health (BMG) via AfD inquiry | NZZ 2025\nError bars show range from extreme scenarios (all unknowns = same group vs opposite group)\nAnalysis: @USMortality | CC BY 4.0"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 10, lineheight = 1.2),
    plot.caption = element_text(hjust = 1, size = 8, lineheight = 1.2, margin = margin(t = 10)),
    axis.text.x = element_text(size = 13, face = "bold"),
    axis.text.y = element_text(size = 11),
    axis.title.y = element_text(size = 13, face = "bold"),
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  ) +
  scale_y_continuous(limits = c(0, max(data$upper) * 1.25), breaks = seq(0, 7, 1))

# Save chart
ggsave("out/covid_death_rates_range.png",
       plot = p, width = 12, height = 8, dpi = 300)

# Print summary
cat("\nDeath Rates (per 1,000 population) - 2021-2024\n")
cat("===============================================\n\n")
cat("CONSERVATIVE ESTIMATE (unknowns = knowns, 8.3% unvax):\n")
cat(sprintf("  Unvaccinated: %.2f per 1,000\n", known_dist[1]))
cat(sprintf("  Vaccinated:   %.2f per 1,000\n", known_dist[2]))
cat(sprintf("  Risk Ratio:   %.2f (vaccinated %.2fx riskier)\n\n", known_dist[2]/known_dist[1], known_dist[2]/known_dist[1]))

cat("PLAUSIBLE RANGE (extreme scenarios):\n")
cat(sprintf("  Unvaccinated: %.2f - %.2f per 1,000\n", all_vax[1], all_unvax[1]))
cat(sprintf("  Vaccinated:   %.2f - %.2f per 1,000\n\n", all_unvax[2], all_vax[2]))

cat("Chart saved as: out/covid_death_rates_range.png\n")
