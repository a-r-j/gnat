library(shiny)
library(nat)
# Use *Input() to create interactive input functions
# Use *Output() to place output areas in app UI
# Outputs built in server function
# Render functions place R objects into output areas designated in the UI

ui <- fluidPage(
  fileInput(inputId = "input_neurons", label = "Upload Neurons",
            accept = c(".swc", ".json", ".nrrd", ".VTK"), multiple = F),
  
  plotOutput(outputId = "neuron_viewer"),
  plotOutput(outputId = "plot_viewer")
  
)

# Use server function to assemble inputs into outputs
# 1. Save output to output$ list
# 2. Build the output with a render*() function
# 3. Access input values with input$ list 
# {} braces allow passing of a multi-line R code block to renderPlot
server <- function(input, output) {
  
  output$neuron_viewer <- renderPlot({
    title = "Neuron Viewer"
    plot2d(input$input_neurons)
  })
}

shinyApp(ui = ui, server = server)
