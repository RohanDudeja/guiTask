#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(gfpop)
# Define UI for application that draw
ui <- fluidPage(

    # Application title
    titlePanel("ShinyApp for gfpop"),

    # Sidebar with a slider input
    sidebarLayout(
        sidebarPanel(
            
            # Input: Selector for choosing dataset ----
            
            
            # Input: Numeric entry 
            numericInput(inputId = "penalty",
                         label = "Penalty parameter",
                         value = 1)
        ),
        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        # generate 
        n <- 400
        mydata <- dataGenerator(n, c(0.2, 0.5, 0.8, 1), c(5, 10, 15, 20), sigma = 1, gamma = 0.966)
        beta <- 2*log(n)
        pen=as.double(input$penalty)
        myGraphDecay <- graph(
            Edge(0, 0, "up", penalty = pen),
            Edge(0, 0, "null", 0, decay = 0.966)
        )
        g <- gfpop(data =  mydata, mygraph = myGraphDecay, type = "mean")
        #g
        gamma <- 0.966
        len <- diff(c(0, g$changepoints))
        signal <- NULL
        for(i in length(len):1){
            signal <- c(signal, g$parameters[i]*c(1, cumprod(rep(1/gamma,len[i]-1))))
        }
        signal <- rev(signal)
        ylimits <- c(min(mydata), max(mydata))
        title<-paste("Penalty = ",format(round(pen, 5), nsmall = 5))
        plot(mydata, type ='p', pch ='+', ylim = ylimits,main=title)
        par(new = TRUE)
        plot(signal, type ='l', col = 4, ylim = ylimits, lwd = 3,ylab="")
        legend('topleft', legend=c("DATA", "GFPOP"),
               col=c("black", "blue"), lty=1:1, cex=0.8)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
