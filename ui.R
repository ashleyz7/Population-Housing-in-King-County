# list of libraries that will be used
library(rsconnect)
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# read in the file and select columns that will be used in our app
FPD.file <- na.omit(read.csv("./FPD.csv", check.names=FALSE))
water.land.use <- select(FPD.file, "City Name", "Land Area (Square Miles) 2000",
                         "Land Area (Square Miles) 2010", "Water Area (%) 2000", "Water Area (%) 2010")
# list city names from the dataframe for users to choose
city.name <- as.character(water.land.use$"City Name")

ui <- navbarPage("Population & Housing in King County",

  # Add introduction texts on the home page                 
  tabPanel("Home",
    tags$head(
        tags$style(HTML(" @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');"))
    ),
           
  titlePanel(   
    h1("WELCOME!", 
      style = "font-family: 'Lobster', cursive;
      font-weight: 500; line-height: 1.1; 
      color: #f7ab9b;")
    ),
  
  mainPanel(
    p(em("Group Name:"), strong("404-NAME-NOT-FOUND")),
    
    p(em("Project Members:"), strong("Ashley(Yufei) Zhou, Eva(Yin) Yuan, Sunny(Kecheng) Sun")),
    
    p("For our final project, we choose to analyze a dataset that focuses on the population and housing of King County
        in the Washington state from 2000 to 2010. The data was originally collected by Washington State Office of Financial
        Management and is currently accessible at", strong("Data.WA.gov.")),
    
    p("Our potential audiences and stakeholders may will be the group of people that want to utilize the housing and
      population information of Washington state to help make certain decisions, including real estates investors,
      dealers, government officials, or others who may be interested in this particular dataset. For example, the real
      estate investorswould like to carefully investigate the current situation of Washington state before making any
      investment decisions. Our assessment and analysis on the population density, land arrangement as well as he housing
      occupancy or vacancy rate will be able to help them decide which region has the most financial growth potential;
      in other words, has the potential to attract future residents. One of our main goals is to select relevant data
      and visualize it so that the data is clear, visually appealing, and interactive to viewers."),
    
    p("In the first dynamic analysis, users can select a city name from the drop down bar and two corresponding 
      pie charts will appear side by side. The one on the left is the land and water use percentages in 2000, 
      the right one is the percentages in 2010. Land use is presented in color brown and water use is in color
      blue as a more direct visualization of these two categories. When users put cursor on
      the pie charts, a hangover box will show the actual area of indicated land or water use."),
    
    p("In the second dynamic analysis, users can search whatever city they what to look at by simplying typing
      the city's name in the searching bar, and corresponding scatter plot graph will appear, with x-axis represents
      the house occupancy rate and y-axis represents the year. By hovering over the points, users will be able to
      see more specific data."),
    
    p("In the third analysis, the user is able to choose from three pre-rendered visualizations: they represent
      population density in 2000, in 2010, and the change, respectively. The visualizations themselves are choropleth
      maps created by Tableau and the Shiny makes the connection between the controls and the visualizations.")
  )
),
  
  # select drop down bar with defult city
  tabPanel("Land & Water Use",
    selectInput("city", "Choose the name of the city:", city.name, selected = "Benton"),
    # use plotly for output
    plotlyOutput("landwaterPlotly")
  ),
  
  # Page that contains allows users to see the Population Rate
  tabPanel("Occupancy Rate",
    # Sidebar with slider input that allows the users to choose the city that they are interested in
    sidebarLayout(
      sidebarPanel(
        textInput(inputId = "my.city", label = "Choose the City", placeholder = "Seattle")
      ),
  
      mainPanel(
        plotlyOutput("plot")
      )
    )
  ),
  
  # creates a select input in which the user is able to choose from any of the opinions
  tabPanel("Population Density", 
           selectInput("vis","Please select one of the data visualizations from below: ",
                       c("2000","2010","change")),
           # set image as the output type
           imageOutput("pic")      
  )  
  
)






