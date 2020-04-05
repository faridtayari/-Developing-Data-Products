#
# This is the user-interface definition of a Shiny web application. You can
# run the application in the RStudio.
#


library(shiny)
library(dplyr)

# read the data from NY Times Github
# https://github.com/nytimes/covid-19-data

urlfile_state<-"https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"
corona_data_state<<-read.csv(urlfile_state)
urlfile_county<-"https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"
corona_data_county<<-read.csv(urlfile_county)

state_names<<-levels(factor(corona_data_state$state))
corona_data_state$date<-as.Date(corona_data_state$date)
corona_data_state_US<<-group_by(corona_data_state,date)
corona_data_state_US1<<-as.data.frame(summarise(corona_data_state_US,sum(cases,na.rm = TRUE)))
names(corona_data_state_US1)[dim(corona_data_state_US1)[2]]<-"cases"
corona_data_state_US2<<-as.data.frame(summarise(corona_data_state_US,sum(deaths,na.rm = TRUE)))
names(corona_data_state_US2)[dim(corona_data_state_US2)[2]]<-"deaths"
corona_data_state_US<<-merge(corona_data_state_US1,corona_data_state_US2)
# if error, use the downloaded file    


shinyUI(

  
      fluidPage(
        headerPanel("U.S. Coronavirus data"),
        uiOutput("Farid_Tayari"),
        br(),
        uiOutput("data_source"),
        uiOutput("updated"),
        uiOutput("Total_cases"),
        uiOutput("Total_deaths"),
        br(),
        fluidRow(
           plotOutput("corona_plot_US")
        #   
         ),
          
        h5("According to The New York Times, \"Case\" refers to a case of coronavirus that is identified after testing."),
        br(),
        
        h2("State level data", align = "center"),

         sidebarPanel(
           selectInput("state_name", "State:", state_names),
           checkboxInput("county_level", "County level data", value = FALSE),
           conditionalPanel(condition="input.county_level==true", selectInput("county_name", "County:",""))),
         mainPanel(
           plotOutput("corona_plot"),
           tableOutput("corona_table")),       


       
              )
      
      )
