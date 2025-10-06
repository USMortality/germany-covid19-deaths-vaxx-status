library(ggplot2)

# Population data
unvax_pop <- 18.4  # million
vax_pop <- 64.9    # million

# Known deaths 2021-2024
unvax_known <- 3000
vax_known <- 33000
unknown <- 114709

# Function to calculate VE given % of unknowns that are unvaccinated
calc_ve_from_pct <- function(pct_unknown_unvax) {
  n_unknown_unvax <- unknown * pct_unknown_unvax / 100

  total_unvax_deaths <- unvax_known + n_unknown_unvax
  total_vax_deaths <- vax_known + (unknown - n_unknown_unvax)

  unvax_rate <- total_unvax_deaths / unvax_pop
  vax_rate <- total_vax_deaths / vax_pop

  rr <- vax_rate / unvax_rate  # Risk Ratio = vax risk / unvax risk
  ve <- (1 - rr) * 100         # Vaccine Efficacy

  data.frame(
    pct_unknown_unvax = pct_unknown_unvax,
    ve = ve,
    rr = rr,
    unvax_rate = unvax_rate * 1000,  # per 1000
    vax_rate = vax_rate * 1000
  )
}

# Generate range of scenarios
pct_range <- seq(0, 100, by = 1)
results <- do.call(rbind, lapply(pct_range, calc_ve_from_pct))

# Create plot
p <- ggplot(results, aes(x = pct_unknown_unvax, y = ve)) +
  geom_line(linewidth = 1.5, color = "#2c3e50") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red", linewidth = 1) +
  geom_vline(xintercept = 8.3, linetype = "dotted", color = "#3498db", linewidth = 1) +
  annotate("text", x = 8.3, y = -150, label = "8.3%\n(known dist.)",
           hjust = -0.1, size = 3.5, color = "#3498db") +
  geom_vline(xintercept = 22.1, linetype = "dotted", color = "#9b59b6", linewidth = 1) +
  annotate("text", x = 22.1, y = -150, label = "22.1%\n(population)",
           hjust = -0.1, size = 3.5, color = "#9b59b6") +
  labs(
    title = "Vaccine Efficacy vs. Unknown Deaths Distribution",
    subtitle = sprintf("What efficacy emerges for different assumptions about %s unknown deaths?",
                      format(unknown, big.mark = ",")),
    x = "% of Unknown Deaths That Are Unvaccinated",
    y = "Vaccine Efficacy (%)",
    caption = "Source: German Federal Ministry of Health (BMG) via AfD inquiry | NZZ 2025\nKnown deaths: 3,000 unvax, 33,000 vax | Population: 18.4M unvax (22.1%), 64.9M vax (77.9%)\nAnalysis: @USMortality | CC BY 4.0"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 11),
    plot.caption = element_text(hjust = 1, size = 8, lineheight = 1.2, margin = margin(t = 10)),
    axis.text = element_text(size = 11),
    axis.title = element_text(size = 12, face = "bold"),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

ggsave("out/covid_ve_by_unknown_pct.png",
       plot = p, width = 12, height = 8, dpi = 300)

# Print key values
cat("\nVaccine Efficacy by Unknown Distribution\n")
cat("==========================================\n\n")

key_pcts <- c(0, 8.3, 22.1, 50, 100)
for (pct in key_pcts) {
  r <- results[abs(results$pct_unknown_unvax - pct) < 0.5,][1,]
  cat(sprintf("%.1f%% unknowns unvax -> VE = %.1f%% (RR = %.2f)\n",
              r$pct_unknown_unvax, r$ve, r$rr))
}

# Calculate probabilities
ve_negative <- sum(results$ve < 0) / nrow(results) * 100
ve_neutral <- sum(results$ve >= -10 & results$ve <= 10) / nrow(results) * 100
ve_positive <- sum(results$ve > 10) / nrow(results) * 100

cat("\n\nAssuming uniform probability over 0-100% unknowns:\n")
cat(sprintf("• Negative efficacy (VE < 0%%): %.0f%% of scenarios\n", ve_negative))
cat(sprintf("• Neutral efficacy (-10%% < VE < 10%%): %.0f%% of scenarios\n", ve_neutral))
cat(sprintf("• Positive efficacy (VE > 10%%): %.0f%% of scenarios\n", ve_positive))

cat("\n\nChart saved as: out/covid_ve_by_unknown_pct.png\n")
