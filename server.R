# list of libraries that will be used
library(rsconnect)
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tibble)

#read in the file and select columns that will be used in our app
FPD.file <- na.omit(read.csv("FPD.csv", check.names=FALSE))
water.land.use <- select(FPD.file, "City Name", "Land Area (Square Miles) 2000", "Land Area (Square Miles) 2010",
                         "Water Area (%) 2000", "Water Area (%) 2010")

server <- function(input, output) {

  # draw two pie charts according to users' input
  output$landwaterPlotly <- renderPlotly({
    #select a specific row according to users' choice of city
    that.city <- subset(water.land.use, water.land.use[,"City Name"] == input$city)
    #add columns for complete information displaying on the pie charts 
    df1 <- add_column(that.city, "Land Area (%) 2000" = 100-that.city[,4], .after = 2)
    df2 <- add_column(df1, "Water Area (Square Miles) 2000" = df1[,2]/df1[,"Land Area (%) 2000"]*100 - df1[,2], .after = 4) 
    df3 <- add_column(df2, "Land Area (%) 2010" = 100-df2[,6], .after = 4) 
    df4 <- add_column(df3, "Water Area (Square Miles) 2010" = df3[,2]/df3[,"Land Area (%) 2010"]*100 - df3[,2], .after = 7)
    # flip the row into a column for conviently obtaining information 
    flip.df <- t(df4)
    # set dataframes of shown statistics
    data.percent.2000 <-as.data.frame(flip.df[c(3,7),])
    data.area.2000 <-as.data.frame(flip.df[c(2,6),])
    data.percent.2010 <-as.data.frame(flip.df[c(5,9),])
    data.area.2010 <-as.data.frame(flip.df[c(4,8),])
    # set blue for water, brown for land
    colors <- c('rgb(179, 119, 0)', 'rgb(102, 153, 255)')
    
    # plot two pie charts with percentages of land use and water use, 
    # actual area statistics in hangover box
    p2000 <- plot_ly(data.percent.2000, labels = rownames(data.percent.2000), values = data.percent.2000[,1], type = "pie", 
                     domain = list(x = c(0, 0.4)),
                     textposition = 'inside',
                     textinfo = 'label+percent',
                     insidetextfont = list(color = '#FFFFFF'),
                     hoverinfo = 'text',
                     text = ~paste(data.area.2000$`flip.df[c(2, 6), ]`, ' Square Miles'),
                     marker = list(colors = colors,
                                   line = list(color = '#FFFFFF', width = 1)),
                     showlegend = FALSE) %>% 
      
      add_trace(labels = rownames(data.percent.2010), values = data.percent.2010[,1], type = "pie", 
                domain = list(x = c(0.6, 1)),
                textposition = 'inside',
                textinfo = 'label+percent',
                insidetextfont = list(color = '#FFFFFF'),
                hoverinfo = 'text',
                text = ~paste(data.area.2010$`flip.df[c(4, 8), ]`, ' Square Miles'),
                marker = list(colors = colors,
                              line = list(color = '#FFFFFF', width = 1)),
                showlegend = FALSE) 
  })

  # get the occupancy rate of 2000 and 2010 for the city that the users want to look at and plot the graph  
  output$plot <- renderPlotly({
    info = subset(FPD.file, FPD.file[, "City Name"]  == input$my.city)
    city.data <- data.frame(
      years = c("2000", "2010"),
      rates = c(info$"Occupancy Rate (%) 2000", info$"Occupancy Rate (%) 2010")
    )
    year <- city.data$years
    rate <- city.data$rates 
    
    graph <- ggplot(data = city.data) +
      geom_point(mapping = aes(x = year, y = rate)) +
      labs(title = "Occupancy Rate in 2000 and 2010",
           x = "Year",
           y = "Occupancy Rate") 
    graph
    
  })
  
  output$pic <- renderImage({
    print(list.files("images"))
    if (input$vis == "2000") {
      list(src = "images/image1.png",height = 500, width = 800)
    } else if (input$vis == "2010") {
      list(src = "images/image2.png", height = 500, width = 800)
    } else {
      list(src = "images/image3.png", height = 500, width = 800)
    }
  },  deleteFile = FALSE)
  
}


  


