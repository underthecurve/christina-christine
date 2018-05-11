## first run processing.R code

library('tidyverse')
library('ggthemes')
library('extrafont')

font_import()

df <- read_csv('data.csv')

ggplot(df, aes(x = year, 
               y = cumulative/1000, 
               group = name, color = name)) + geom_line(size = 2) + 
scale_color_manual(values = c('#003399', '#5d5d5d')) + labs(x = '', y = '') +
  theme_bw() + theme_fivethirtyeight() + 
  scale_y_continuous(limits = c(0, 300), breaks = seq(0, 300, 50)) +
  scale_x_continuous(breaks = seq(1980, 2016, 7), 
                     labels = c("1980", "'87", "'94", "2001", "'08", "'15")) +
  theme(panel.background = element_rect(fill = "white"), 
        plot.background = element_rect(fill = "white"), 
        panel.grid.major = element_line(color = 'gray90', size = .3), 
        axis.text = element_text(size = 16, family = "mono"), 
        plot.title = element_text(size = 20, face = "bold", family = "mono"),
        plot.subtitle = element_text(size = 14, family = "mono"),
        legend.position = 'none', 
        plot.caption = element_text(hjust = -.01, color = 'gray47', size = 9, family = "mono")) +
  ggtitle('Christina > Christine :-(') + 
  labs(caption = '\n\n*Data from the Social Security Administration\nbased on Social Security card applications for U.S. births since 1980', subtitle = "cumulative U.S. births since 1980\n") 
  
ggsave('plot.png', width = 8, height = 6.5)
