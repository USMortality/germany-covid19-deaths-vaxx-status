library(ggplot2)
library(dplyr)

# Data breakdown by period
data <- data.frame(
  period = rep(c("2020\n(Pre-vaccine)", "2021-2024\n(Vaccine era)"), each = 3),
  status = rep(c("Unvaccinated", "Vaccinated", "Unknown"), 2),
  deaths = c(
    36000, 0, 291,      # 2020
    3000, 33000, 114709  # 2021-2024
  )
)

# Order the status factor
data$status <- factor(data$status, levels = c("Unvaccinated", "Vaccinated", "Unknown"))

# Create grouped bar chart
p <- ggplot(data, aes(x = period, y = deaths, fill = status)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", linewidth = 0.8) +
  scale_fill_manual(values = c("Unvaccinated" = "#e74c3c",
                                 "Vaccinated" = "#27ae60",
                                 "Unknown" = "#95a5a6")) +
  geom_text(aes(label = ifelse(deaths > 0, format(deaths, big.mark = ","), "")),
            position = position_dodge(width = 0.9),
            vjust = -0.5, size = 3.5, fontface = "bold") +
  labs(title = "COVID-19 Deaths in Germany by Period and Vaccination Status",
       subtitle = "Total: 187,000 deaths (2020-2024) | Based on Ministry Data",
       y = "Number of Deaths",
       x = "",
       fill = "Vaccination Status",
       caption = "Source: German Federal Ministry of Health (BMG) via AfD inquiry | NZZ 2025\nAnalysis: @USMortality | CC BY 4.0") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 15, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 11),
        plot.caption = element_text(hjust = 1, size = 8, lineheight = 1.2, margin = margin(t = 10)),
        axis.text = element_text(size = 11),
        axis.title.y = element_text(size = 12, face = "bold"),
        legend.position = "bottom",
        legend.title = element_text(face = "bold", size = 11),
        legend.text = element_text(size = 10),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, 125000))

# Save chart
ggsave("out/covid_deaths_grouped.png",
       plot = p, width = 12, height = 7, dpi = 300)

cat("Grouped chart saved as: out/covid_deaths_grouped.png\n")
