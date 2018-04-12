library(shiny)
library(nat)

ui <- fluidPage(
  # *Input() functions,
  # *Output() functions
  
  print("Neuron Input"),
  fileInput(inputId = "input_neurons", label = "Upload Neurons",
            accept = c(".swc", ".json", ".nrrd", ".VTK"), multiple = F),
  
  
  # *Outout() adds space in the UI for R Object - output must be built in output function
  plotOutput(outputId = "neuron_viewer"),
  plotOutput(outputId = "plot_viewer")
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
