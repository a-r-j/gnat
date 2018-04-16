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
  # LOGIN
  logged_in <- reactiveVal(FALSE)
  
  # switch value of logged_in variable to TRUE after login succeeded
  observeEvent(input$login, {
    logged_in(ifelse(logged_in(), FALSE, TRUE))
    shinyalert(
      title = "What is your name?", type = "input",
      callbackR = function(value) { shinyalert(paste("Welcome", value)) })
  })
  
  # show "Login" or "Logout" depending on whether logged out or in
  output$logintext <- renderText({
    if(logged_in()) return("Logout here.")
    return("Login here")
  })
  
  # show text of logged in user
  output$logged_user <- renderText({
    if(logged_in()) return("Welcome, USER")
    return("")
  })
  
  login<- reactiveValues()
  login$submit=FALSE
  observeEvent(input$Login,
               {
                # login$submi!!=input$Login
                 catmaid_conn = catmaid_login(
                   input$catmaid_login_server,
                   input$catmiad_login_token,
                   input$catmaid_login_authname,
                   input$catmaid_login_authpassword
                 )
               })

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
        menuItem("Analysis & Manipulation", icon = icon("th"), tabName = "tab_analysis"),
        menuItem("Plotting", icon = icon("bar-chart-o"),
                 menuSubItem("Morphology", tabName = "plotting_morphology"),
                 menuSubItem("Quant", tabName = "plotting_quant")),
        menuItem("Data Output", icon = icon("angle-down"), tabName = "tab_output"),
        menuItem("R editor", icon = icon("code"), tabName = "tab_editor"))
  })
  

  
  # Render 3D Widgets
  output$view3d_pairwise <- renderRglwidget({
    rgl.open(useNULL=T)
    clear3d()
    plot3d(FCWB)
    #frontalView()
    rglwidget()
  })
  
  output$plot_selections <- DT::renderDataTable(mtcars, filter="top", options=list(autoWidth=TRUE))
  
  # R CONSOLE
  
  # thedata <- reactive({
  #   data.frame(V1 = rnorm(input$n),
  #              V2 = rep("A",input$n))
  # })
  
  output$output <- renderPrint({
    input$eval
    return(isolate(eval(parse(text=input$code))))
  }) 
  
  # GLOBAL ENVIRONMENT
  
  # Filter data based on selections
  currentVars <- reactive({cbind(objects(), objects())})
  
  # Produce global environment table
  output$table <- DT::renderDataTable(currentVars)
 
})