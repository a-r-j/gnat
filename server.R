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
library(shinyRGL)
library(rglwidget)

shinyServer(function(input,output,session){
  # SIDEBAR
  
  # Make collapsible
  vals<-reactiveValues()
  vals$collapsed=FALSE
  observeEvent(input$SideBar_col_react,
               {
                 vals$collapsed=!vals$collapsed
               }
  )
  # Render sidebar
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
        menuItem("CATMAID", tabName = "tab_catmaid", icon = icon("server")),
        menuItem("Data Input", icon = icon("angle-up"), tabName = "tab_input"),
        menuItem("Analysis & Manipulation", icon = icon("th"), tabName = "tab_analysis", badgeLabel = "new",
                 badgeColor = "green"),
        menuItem("Plotting", icon = icon("bar-chart-o"),
                 menuSubItem("Morphology", tabName = "plotting_subitem1"),
                 menuSubItem("Quantit", tabName = "plotting_subitem2")),
        menuItem("Data Output", icon = icon("angle-down"), tabName = "tab_output"),
        menuItem("R editor", icon = icon("code"), tabName = "tab_editor"))
  })
  
  # R CONSOLE
  
  # thedata <- reactive({
  #   data.frame(V1 = rnorm(input$n),
  #              V2 = rep("A",input$n))
  # })
  
  # Render 3D Widgets
  output$view3d_pairwise <- renderRglwidget({
    rgl.open(useNULL=T)
    clear3d()
    plot3d(FCWB)
    #frontalView()
    rglwidget()
  })
  
  output$output <- renderPrint({
    input$eval
    return(isolate(eval(parse(text=input$code))))
  }) 
  
  # Global Environment
  
  # Filter data based on selections
  currentVars <- reactive({cbind(objects(), objects())})
  
  # Produce global environment table
  output$table <- DT::renderDataTable(currentVars)
})



# server <- function(input, output, session) {
#   catmiad_conn = catmaid_login(
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
