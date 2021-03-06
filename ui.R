library(shiny)
library(shinyjs)
library(shinydashboard)
library(nat)
library(catmaid)
library(ggplot2)
library(DT)
library(dashboardthemes)
library(rgl)
library(shinyRGL)
library(rglwidget)
library(colourpicker)
library(shinyalert)
library(shinymaterial)
library(rmarkdown)
library(shinyAce)
# Use *Input() to create interactive input functions
# Use *Output() to place output areas in app UI
# Outputs built in server function
# Render functions place R objects into output areas designated in the UIinsta
material_page(dashboardPage(skin="black",
                            dashboardHeader(title="Gnat",
                                            tags$li(class = "dropdown",
                                                    tags$li(class = "dropdown", textOutput("logged_user"), style = "padding-top: 15px; padding-bottom: 15px; color: black;"),
                                                    tags$li(class = "dropdown", actionLink("login", textOutput("logintext"))))
                            ),
                            dashboardSidebar(sidebarMenuOutput("Semi_collapsible_sidebar")),
                            dashboardBody(tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                          #shinyDashboardThemes(theme = "grey_dark"),
                                          
                                          useShinyalert(),  # Set up shinyalert
                                          #actionButton("preview", "Preview"),
                                          material_modal(
                                            modal_id = "example_modal",
                                            button_text = "Modal",
                                            button_icon = "open_in_browser",
                                            title = "Showcase Modal Title",
                                            h3("Instructions"),
                                            HTML("Interact with <b><span style='color: black;'>CATMAID</span></b> based on selections made elsewhere in <span style='color: red;'>gnat</span>."),
                                            h3("CATMAID Login"),
                                            textInput("catmaid_login_server",label = "Server"),
                                            textInput("catmaid_login_token", label = "Token"),
                                            textInput("catmaid_login_authname", label = "Auth name"),
                                            textInput("catmaid_login_authpassword", label = "Auth Password"),
                                            submitButton("Login")
                                          ),
                                          tabItems(
                                            tabItem(tabName = "tab_catmaid",
                                                    fluidRow(
                                                      column(width = 6,
                                                             tabBox(
                                                               title = "Skeleton Functions", width = NULL, id = "tabset_catmaid_skeleton_funcs",
                                                               tabPanel("Get Compact Skeleton",
                                                                        textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Compact Skeleton"),
                                                                        selectizeInput(inputId = "catmaid_skid_input", label = NULL , choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                        actionButton(inputId ="catmaid_skeleton_btn", label = "Call" ),
                                                                        br(),
                                                                        HTML("<i>Return the raw data for a CATMAID neuronal skeleton</i>")
                                                                        
                                                               ),
                                                               
                                                               tabPanel("Get Treenode Table",
                                                                        textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Treenode Table"),
                                                                        selectizeInput(inputId = "catmaid_skid_input", label = NULL, choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                        actionButton(inputId ="catmaid_skeleton_btn", label = "Call" ),
                                                                        br(),
                                                                        HTML("<i>Return tree node table for a given neuron</i>")
                                                               ),
                                                               
                                                               tabPanel("Get Review Status",
                                                                        textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Review Status"),
                                                                        selectizeInput(inputId = "catmaid_skid_input", label = NULL, choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                        actionButton(inputId ="catmaid_skeleton_btn", label = "Call"),
                                                                        br(),
                                                                        HTML("<i>Get review status of neurons from CATMAID</i>")
                                                               )
                                                             )
                                                             
                                                      ),
                                                      
                                                      fluidRow(
                                                        column(width = 6,
                                                               box(
                                                                 title = "Naming & Annotation Utilities", width = NULL, status = "primary",
                                                                 selectizeInput(inputId = "catmaid_skid_input", label = "Get Compact Skeleton", choices = ""),
                                                                 selectizeInput(inputId = "catmaid_skid_input", label = "Get Treenode Table", choices = ""),
                                                                 selectizeInput(inputId = "catmaid_skid_input", label = "Get Review Status", choices = "")
                                                               )
                                                        )
                                                      ),
                                                      fluidRow(
                                                        column(width = 12, offset = 0,
                                                               tabBox(
                                                                 title = "Connectivity Utilities", width = NULL, id = "tabset_catmaid_skeleton_funcs",
                                                                 tabPanel("Query Connected",
                                                                          textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Query Connected"),
                                                                          selectizeInput(inputId = "catmaid_skid_input", label = NULL , choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                          actionButton(inputId ="catmaid_skeleton_btn", label = "Call" ),
                                                                          br(),
                                                                          HTML("<i>Find neurons connected to a starting neuron</i>")
                                                                          
                                                                 ),
                                                                 
                                                                 tabPanel("Get Connector Table",
                                                                          textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Connector Table"),
                                                                          selectizeInput(inputId = "catmaid_skid_input", label = NULL, choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                          actionButton(inputId ="catmaid_skeleton_btn", label = "Call" ),
                                                                          br(),
                                                                          HTML("<i>Return connector table for a given neuron</i>")
                                                                 ),
                                                                 
                                                                 tabPanel("Get Connectors Between",
                                                                          textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Connectors Between"),
                                                                          selectizeInput(inputId = "catmaid_skid_input", label = NULL, choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                          actionButton(inputId ="catmaid_skeleton_btn", label = "Call"),
                                                                          br(),
                                                                          HTML("<i>Return information about connectors joining sets of pre/postsynaptic skids</i>")
                                                                 ),
                                                                 
                                                                 tabPanel("Get Connectors",
                                                                          textInput(inputId="catmaid_var_name", placeholder = "Variable Name", label = "Get Connectors"),
                                                                          selectizeInput(inputId = "catmaid_skid_input", label = NULL, choices = "", options = list(placeholder = "Select Skid(s)")),
                                                                          actionButton(inputId ="catmaid_skeleton_btn", label = "Call"),
                                                                          br(),
                                                                          HTML("<i>Return skeleton ids for pre/postsynaptic partners of a set of connector_ids</i>")
                                                                          
                                                                 )
                                                               )
                                                               
                                                        )
                                                      )
                                                    )
                                            ),
                                            tabItem(tabName = "tab_input",
                                                    column(width = 6,
                                                           box(
                                                             fileInput(inputId = "input_neurons", label = "Upload Neurons",
                                                                       accept = c(".swc", ".json", ".nrrd", ".VTK"), multiple = F)
                                                           )
                                                           
                                                    )
                                            ),
                                            
                                            tabItem(tabName = "tab_analysis",
                                                    column(width = 6,
                                                           box(
                                                             title = "Skeleton Functions", width = NULL, status = "primary",
                                                             selectizeInput(inputId = "catmaid_skid_input", label = "Get Compact Skeleton", choices = ""),
                                                             HTML("<i>Return the raw data for a CATMAID neuronal skeleton</i>"),
                                                             br(),
                                                             selectizeInput(inputId = "catmaid_skid_input", label = "Get Treenode Table", choices = ""),
                                                             HTML("<i>Return tree node table for a given neuron</i>"),
                                                             br(),
                                                             selectizeInput(inputId = "catmaid_skid_input", label = "Get Review Status", choices = ""),
                                                             HTML("<i>Get review status of neurons from CATMAID</i>"),
                                                             br()
                                                           )
                                                           
                                                    )
                                            ),
                                            tabItem(tabName = "plotting_morphology",
                                                    h2("3D view"),
                                                    #includeCSS("loader.css"),
                                                    HTML("<div class='loader' style='position: absolute; left: 400px; top: 300px; z-index: -10000;'>Loading...</div>"),
                                                    HTML("<div style='position: absolute; left: 220px; top: 270px; z-index: -10000; text-align: center; width: 400px; font-size: 30px;'>Loading...</div>"),
                                                    fluidRow(column(5,
                                                                    tabBox(width="100%", height = "800px",
                                                                           tabPanel("1",
                                                                                    #HTML("<div class='loader' style='position: absolute; left: 400px; top: 300px; z-index: -10000;'>Loading...</div>"),
                                                                                    #HTML("<div style='position: absolute; left: 220px; top: 270px; z-index: -10000; text-align: center; width: 400px; font-size: 30px; text-color: black;'>Loading...</div>"),
                                                                               
                                                                                    rglwidgetOutput("view3d_pairwise", width="100%", height="725px"))
                                                                           )
                                                                    ),
                                                      
                                                      column(7,
                                                             box(title = "Plot Parameters", width = "100%", status = "primary",
                                                                 fluidRow(
                                                                   column(3,
                                                                          selectizeInput(inputId = "plot_skid_input", label = "Add to Plot", choices = "")),
                                                                   column(3,
                                                                          radioButtons(inputId = "plot_syn", label = "Plot Synapses?", choices = c("Yes", "No"))
                                                                   ),
                                                                   column(3,
                                                                          colourInput("plot_col", "Select colour", "yellow")),
                                                                   column(3,
                                                                          actionButton(inputId = "plot_submit", label = "Plot"))
                                                                 )
                                                             ),
                                                             box(title = "Plot Selections", width="100%", height = "100%", status = "primary",
                                                                 fluidRow(
                                                                   DT::dataTableOutput("plot_selections"),
                                                                   actionButton(inputId = "plot_table_remove", label = "Remove"),
                                                                   actionButton(inputId = "plot_table_suppress", label = "Suppress")))
                                                      )
                                                    ),
                                                    
                                                    conditionalPanel(condition = "output.pairwise_nblast_complete",
                                                                     h2("NBLAST results"),
                                                                     textOutput("pairwise_query_target"),
                                                                     textOutput("pairwise_results"),
                                                                     HTML("<a href='http://flybrain.mrc-lmb.cam.ac.uk/si/nblast/www/how/'>What do these scores mean?</a>")
                                                    )
                                                    
                                            ),
                                            tabItem(tabName = "tab_editor",
                                                    aceEditor("code","library(nat) \nlibrary(catmaid) \n", theme = "terminal"),
                                                    actionButton("eval","Evaluate code"),
                                                    verbatimTextOutput("output")
                                            )
                                          ),
                                          fluidRow(
                                            tabBox(
                                              title = "R Environment",
                                              # The id lets us use input$tabset1 on the server to find the current tab
                                              id = "tabset1", height = "250px", width = 12,
                                              tabPanel(icon("terminal"),"CONSOLE GOES HERE"
                                                       # fluidRow(aceEditor("code","library(nat) \nlibrary(catmaid) \n", theme = "terminal"),
                                                       #          actionButton("eval","Evaluate code"),
                                                       #          verbatimTextOutput("output"))
                                              ),
                                              tabPanel(icon("globe"),"GLOBAL ENVIRONMENT GOES HERE",
                                                       # Create a new Row in the UI for selectInputs
                                                       # fluidRow(
                                                       #   column(3,
                                                       #          selectInput("environment_nl",
                                                       #                      "Neuronlists:",
                                                       #                      c("All",
                                                       #                        unique(as.character(mpg$manufacturer))))
                                                       #   ),
                                                       #   column(3,
                                                       #          selectInput("environment_str",
                                                       #                      "Strings:",
                                                       #                      c("All",
                                                       #                        unique(as.character(mpg$trans))))
                                                       #   ),
                                                       #   column(3,
                                                       #          selectInput("environment_vals",
                                                       #                      "Values:",
                                                       #                      c("All",
                                                       #                        unique(as.character(mpg$cyl))))
                                                       #   ),
                                                       #   column(3,
                                                       #          selectInput("environment_dfs",
                                                       #                      "Dataframes:",
                                                       #                      c("All",
                                                       #                        unique(as.character(mpg$cyl))))
                                                       #   )
                                                       # ),
                                                       # Create a new row for the table.
                                                       fluidRow(
                                                         DT::dataTableOutput("table")
                                                       )
                                              )
                                            )
                                          )
                            )
)
)

# ui <- fluidPage(
#   useShinyjs(),
#   ###################
#   #     Catmaid     #
#   ###################
#   navbarPage(
#             tabPanel("Catmaid",
#                     div( id="Sidebar", 
#            #includeCSS("errors.css"),
#            #shinyURL.ui(display=F),
#                         sidebarLayout(
#                                       sidebarPanel(
#                                  # includeHTML("url.js"),
#                                  # hashProxy("hash"),
#                                                     h3("Instructions"),
#                                                     HTML("Interact with <b><span style='color: black;'>CATMAID</span></b> based on selections made elsewhere in <span style='color: red;'>gnat</span>."),
#                                                     h3("CATMAID Login"),
#                                                     textInput("catmaid_login_server",label = "Server"),
#                                                     textInput("catmaid_login_token", label = "Token"),
#                                                     textInput("catmaid_login_authname", label = "Auth name"),
#                                                     textInput("catmaid_login_authpassword", label = "Auth Password"),
#                                                     submitButton("Login")
#                                                     ),
#                                
#                                       mainPanel(
#                                                 h3("Catmaid Functions"),
#                                                 actionButton("toggleSidebar", "Toggle sidebar")
#                                                )
#                                       )
#                       )
#                   )
#