setwd('~/Developer/reddit-awards-data')

library(data.table)
library(ggplot2)
library(extrafont)

data = read.csv('data.csv')
data = data[data$award_name != '[deleted]', ]
data$count = 1

# Aggregate counts of awards by subreddit and award type
aggregated = aggregate(
  data$count, 
  by = list(
    subreddit = data$subreddit, 
    award_name = data$award_name
  ), 
  sum
)

# Aggregate counts of awards by subreddit
total_by_subreddit = aggregate(
  data$count, 
  by = list(
    subreddit = data$subreddit
  ), 
  sum
)

# Order by most awarded subreddit
total_by_subreddit = total_by_subreddit[order(-total_by_subreddit$x), ]

# Aggregate counts of awards by award type
total_by_awards = aggregate(
  data$count, 
  by = list(
    award_name = data$award_name
  ), 
  sum
)

# Order by most awarded award
total_by_awards = total_by_awards[order(-total_by_awards$x), ]

# Number of top award types and subreddits to plot
NUM_AWARDS_TO_PLOT = 16
NUM_SUBREDDITS_TO_PLOT = 16

# Set the subreddit value label to "Other" if not in top
aggregated$subreddit_label = ifelse(
  aggregated$subreddit %in% total_by_subreddit[1:NUM_SUBREDDITS_TO_PLOT, 1], 
  aggregated$subreddit, 
  'Other'
)

# Set the award lavel to "Other" if not in top
aggregated$award_label = ifelse(
  aggregated$award_name %in% total_by_awards[1:NUM_AWARDS_TO_PLOT, 1], 
  aggregated$award_name, 
  'Other'
)

# Subset to remove "Other"'s from the dataset
aggregated_not_other = aggregated[which(aggregated$subreddit_label != 'Other'), ]
aggregated_not_other = aggregated_not_other[which(aggregated_not_other$award_label != 'Other'), ]

# Plot
ggplot(
  aggregated_not_other, 
  aes(
    x = factor(subreddit_label, total_by_subreddit[1:NUM_SUBREDDITS_TO_PLOT, 1]), 
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
    fill = "Num Times Awarded",
    caption = "Data visualization by randomo_redditor"
  ) + 
  scale_fill_gradient2(
    "Number of Times Awarded", 
    limits = c(0, max(aggregated_not_other$x)), 
    low = "#762A83", 
    mid = "white", 
    high = "#1B7837"
  ) +
  scale_x_discrete(
    position = "top"
  ) +
  theme_stata() +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(), 
    axis.ticks = element_blank(),
    axis.text.y = element_text(angle = 360),
    axis.text.x = element_text(angle = 45,  hjust = -0.005),
    plot.title = element_text(size = 20),
    axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 20)),
    axis.title.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    plot.subtitle = element_text(margin = margin(t = 5, r = 0, b = 20, l = 0), color = "darkgray"),
    plot.margin = unit(c(1, 5, 2, 1), "cm"),
    plot.caption = element_text(color = "darkgray", vjust = -15, hjust = -0.4)
  )

