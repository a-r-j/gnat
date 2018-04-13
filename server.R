# Use server function to assemble inputs into outputs
# 1. Save output to output$ list
# 2. Build the output with a render*() function
# 3. Access input values with input$ list 
# {} braces allow passing of a multi-line R code block to renderPlot
library(shiny)
library(shinydashboard)
library(shinyAce)
library(ggplot2)
library(DT)

shinyServer(function(input,output,session){
  # Sidebat
  vals<-reactiveValues()
  vals$collapsed=FALSE
  observeEvent(input$SideBar_col_react,
               {
                 vals$collapsed=!vals$collapsed
               }
  )

  output$Semi_collapsible_sidebar<-renderMenu({
    if (vals$collapsed)
      sidebarMenu(
        menuItem(NULL, tabName = "dashboard", icon = icon("dashboard")),
        menuItem(NULL, icon = icon("th"), tabName = "widgets",
                 badgeColor = "green"),
        menuItem(NULL, icon = icon("bar-chart-o"),
                 menuSubItem(span(class="collapsed_text","Sub-item 1"), tabName = "subitem1"),
                 menuSubItem(span(class="collapsed_text","Sub-item 2"), tabName = "subitem2")
        ))
    else
      sidebarMenu(
        menuItem("CATMAID", tabName = "tab_catmaid", icon = icon("dashboard")),
        menuItem("Analysis & Manipulation", icon = icon("th"), tabName = "tab_analysis", badgeLabel = "new",
                 badgeColor = "green"),
        menuItem("Plotting", icon = icon("bar-chart-o"),
                 menuSubItem("Sub-item 1", tabName = "subitem1"),
                 menuSubItem("Sub-item 2", tabName = "subitem2")),
        menuItem("R editor", icon = icon("code"), tabName = "tab_editor")
        )
  })
  
  # R Console
  # thedata <- reactive({
  #   data.frame(V1 = rnorm(input$n),
  #              V2 = rep("A",input$n))
  # })
  
  output$output <- renderPrint({
    input$eval
    return(isolate(eval(parse(text=input$code))))
  }) 
  
  # Filter data based on selections
  currentVars <- reactive({cbind(objects(), objects())})
  
  output$table <- DT::renderDataTable(currentVars)
})



# server <- function(input, output, session) {
#   catmaid_login(
#     input$catmaid_login_server,
#     input$catmiad_login_token,
#     input$catmaid_login_authname,
#     input$catmaid_login_authpassword
#   )
#   
#   observeEvent(input$toggleSidebar, {
#     shinyjs::toggle(id = "Sidebar")
#   })
#   
#   # output$neuron_viewer <- renderRglwidget({
#   #   title = "Neuron Viewer"
#   #   #plot3d(input$input_neurons)
#   # })
# }
