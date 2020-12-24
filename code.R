setwd('~/Developer/reddit-awards-data')

library(data.table)
library(ggplot2)

data = read.csv('data.csv')
data = data[data$award_name != '[deleted]', ]
data$count = 1

aggregated = aggregate(
  data$count, 
  by = list(
    subreddit = data$subreddit, 
    award_name = data$award_name
  ), 
  sum
)

total_by_subreddit = aggregate(
  data$count, 
  by = list(
    subreddit = data$subreddit
  ), 
  sum
)

total_by_subreddit = total_by_subreddit[order(-total_by_subreddit$x), ]

total_by_awards = aggregate(
  data$count, 
  by = list(
    award_name = data$award_name
  ), 
  sum
)

total_by_awards = total_by_awards[order(-total_by_awards$x), ]

NUM_AWARDS_TO_PLOT = 12

aggregated$award_label = ifelse(
  aggregated$award_name %in% total_by_awards[1:NUM_AWARDS_TO_PLOT, 1], 
  aggregated$award_name, 
  'Other'
)

aggregated_not_other = aggregated[which(aggregated$award_label != 'Other'), ]

ggplot(
  aggregated_not_other, 
  aes(
    x = factor(subreddit, total_by_subreddit[, 1]), 
    y = factor(award_label, rev(total_by_awards[1:NUM_AWARDS_TO_PLOT, 1])), 
    fill = x,
  )
) + 
  geom_tile(color = "white", alpha = 0.8) + 
  geom_text(
    aes(label = x), 
    size = 3
  ) +
  coord_equal(ratio = 1) + 
  labs(
    x = "Subreddit\n",
    y = "Award Name",
    title = "Most Awarded Reddit Awards",
    subtitle = "From Each Subreddit's Top 100 All-Time Posts",
    fill = "Num Times Awarded"
  ) + 
  scale_x_discrete(position = "top") +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(), 
    axis.ticks = element_blank(),
    strip.text.y = element_text(size = 12, angle = 180),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size = 20),
    axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 10)),
    axis.title.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    plot.subtitle = element_text(margin = margin(t = 5, r = 0, b = 20, l = 0)),
  )
