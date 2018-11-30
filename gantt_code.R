library(plotly)
library(RColorBrewer)

f <- list(
  family = "Courier New, monospace",
  size = 18,
  color = "#7f7f7f"
)
x <- list(
  title = "Date",
  titlefont = f
)
# y <- list(
#   title = "Task Number",
#   titlefont = f
# ) 

df <- readxl::read_xlsx("00_Time_Plan/timeplan.xlsx", sheet = 1) 

df$start <- as.Date(df$start, format="%Y-%m-%d")
cols <- brewer.pal(length(unique(factor(df$Chapter))), name = "Set3") # This won't work if column has blanks
df$color <- factor(df$Chapter, labels = cols)

# annotation
a <- list(text = "Today's date",
          x = Sys.Date(),
          y = 1.02,
          xref = 'x',
          yref = 'paper',
          xanchor = 'left',
          showarrow = FALSE
)

# use shapes to create a line
l <- list(type = line,
          x0 = Sys.Date(),
          x1 = Sys.Date(),
          y0 = 0,
          y1 = 1,
          xref = 'x',
          yref = 'paper',
          line = list(color = 'black',
                      width = 0.7)
)

p <- plot_ly()
for(i in 1:(nrow(df) - 1)){
  p <- add_trace(p,
                 x = c(df$start[i], df$start[i] + df$Duration[i]), 
                 y = c(i, i), 
                 mode = "lines",
                 line = list(color = df$color[i], width = 20),
                 showlegend = F,
                 hoverinfo = "text",
                 text = paste("Task: ", df$Task[i], "<br>",
                              "Duration: ", df$Duration[i], "days<br>",
                              "Chapter: ", df$Chapter[i], "<br>",
                              "Status: ", df$Progress[i]), "<br>",
                 evaluate = T
  )
}

p %>%
  layout(xaxis = x, 
         title = "Thesis Schedule",
         annotations = a,
         shapes = l)

