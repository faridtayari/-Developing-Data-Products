#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output, session) {
        
    
        output$Farid_Tayari = renderUI({a("Farid Tayari", href=("mailto:farid.tayari@gmail.com"))})
        url <- a("NYTimes Github", href="https://github.com/nytimes/covid-19-data")
        output$data_source <- renderUI({
            tagList("Data source:", url)
        })
 
        corona_data_state_set<<-reactive({corona_data_state[corona_data_state$state==input$state_name,]})
        output$updated = renderUI({paste ("Updated on:", format(range(as.Date(corona_data_state_set()$date))[2],"%B %d %Y"))})
        
        output$Total_cases = renderUI({paste ("Total cases:", corona_data_state_US[dim(corona_data_state_US)[1],2])})
        output$Total_deaths = renderUI({paste ("Total deaths:", corona_data_state_US[dim(corona_data_state_US)[1],3])})
        
        
        
        output$corona_plot_US <- renderPlot({ 
            corona_case <- corona_data_state_US$cases
            
            corona_death <- corona_data_state_US$deaths
            corona_date <- as.Date(corona_data_state_US$date)
            
            plot(corona_date,corona_case, ylim= range(corona_case), xlab='', ylab='',main= "United States", type = "l", col="blue")
            par(new=TRUE)
            plot(corona_date,corona_death, ylim= range(corona_case), xlab='', ylab='',main= "", type = "l", col="red")
            legend("topleft",legend= c("Cases","Deaths"), col=c("blue","red"),lty=1)
        
        })
        
        
        observeEvent(corona_data_state_set(),{
           corona_data_county_set<<-corona_data_county[corona_data_county$state==input$state_name,]
           county_name_serv<<-levels(factor(corona_data_county_set$county)) 
           updateSelectInput(session,"county_name",choices =county_name_serv)
                })                

        output$corona_table <- renderTable({            
 
        if (!(input$county_level)){corona_data_state_set()[c("date","state","cases","deaths")]}
        else {
            
            req(input$county_name)
            corona_data_county_set1<<-corona_data_county_set[corona_data_county_set$county==input$county_name,]
            #corona_data_county_set1<-corona_data_county_set1()
            corona_data_county_set1[c("date","state","county","cases","deaths")]
            }
            
    }, rownames = FALSE)
    
    output$corona_plot <- renderPlot({
    corona_case <- corona_data_state_set()$cases
    
    corona_death <- corona_data_state_set()$deaths
    corona_date <- as.Date(corona_data_state_set()$date)
    
    plot(corona_date,corona_case, ylim= range(corona_case), xlab='', ylab='',main= input$state_name, type = "l", col="blue")
    par(new=TRUE)
    plot(corona_date,corona_death, ylim= range(corona_case), xlab='', ylab='',main= "", type = "l", col="red")
    legend("topleft",legend= c("Cases","Deaths"), col=c("blue","red"),lty=1)
        })
    
    
})
