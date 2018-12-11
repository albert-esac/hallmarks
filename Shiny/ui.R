jsCode = '$(".StudyDiv").prependTo(".dt-buttons")'

function(request) {
  shinyjs::useShinyjs()
  SelectStudy <- function()
	div(id = "studyform",
	    style="width:100%",
  	    tags$a(name="Select_Studies", h3("Select Studies")),
	    actionButton("clearStudies", "Clear All Selected"),
            DT::dataTableOutput('study')
        )

  SelectSample <- function()
        div(id = "sampleform",
	    style="width:100%",
            tags$a(name="Select_Samples", h3("Select Samples")),
            actionButton("clearSamples", "Clear All Selected"),
            downloadButton("downloadSamples", "Download data for selected Samples"),
            DT::dataTableOutput('DB')
        )

  Visualize <- function() 
     sidebarLayout(
      mainPanel(width=7,
        plotOutput("radarImage", width="800px", height="800px")),

      sidebarPanel(width=5,
        h2("Legend"),
	checkboxGroupInput("SelectLgColumn", "Column Select:", 
	choices=list("Repository_Accession","Cancer_Model","Biosample_ID","Biosample_Name","Cohort","Strain","Subtype","Tissue","Cell_Type","Cell_Line","Treatment","Biosample_Description"),
	selected=list("Repository_Accession","Cancer_Model","Biosample_ID"),
	width = '100%',inline = TRUE),
	br(),
	uiOutput("Legend")
      )
     ) 

  Upload <- function() 
    div(
       wellPanel(
          tags$a(name="Upload_Data", h3("Upload Data")),
          fileInput('file1', 'Choose file to upload',
                    accept = c(
                      'text/tab-separated-values',
                      'text/plain',
		                  '.txt',
                      '.csv',
                      '.tsv'
                    )),
          tags$hr(),
          p('Sample file:',
             a(href = 'min.txt', 'min.txt')
          ),
	  p("(The first column could be Human/Mouse Gene Symbols or Entrez ID)", style = "font-size:13px"),
          DT::dataTableOutput('Uploaded')
      ),
      wellPanel(
          p("Select the correct cancer pathology type"),
          selectInput('Cancer', 'Cancer', Cancers) ,
          downloadButton("downloadScores", "Download Scores"),
          DT::dataTableOutput('Scored')
      )
   )
  Tutor <- function() 
    div(
      tags$a(name="Tutorhead", h3("Tutorial Example - visualizing the uploaded data")),
      wellPanel(
        tags$a(name="step", h4("Step 1")),
        p("Prepare the RNA-seq data as log2(n+1) normalized values in the following format." , style = "font-size:14px"),
        tableOutput('exptab'),
        p("The first row should be the titles contain gene and sample names and the first column should be the list of genes (Human gene names/gene IDs or mouse gene names/gene IDs are all accessible)." , style = "font-size:14px"),
        tags$a(name="step", h4("Step 2")),
        p("Click on \"Upload\" tab and click \"Browse\" button  to select and open your file. The OMF scores of these samples were then be calculated and showed on the next table." , style = "font-size:14px"),
        tags$a(name="step", h4("Step 3")),
        p("Select the correct cancer model on the drop-down cancer list. The samples with the OMF scroes of the corresponding cancer model were automatically added to the sample lists.", style = "font-size:14px"),
        tags$a(name="step", h4("Step 4")),
        p("Click on \"Select Sample\" tab and then click \"Clear All Selected\" to clear the pre-selected samples. Click on each sample row to select the samples." , style = "font-size:14px"),
        tags$a(name="step", h4("Step 5")),
        p("Click on \"Visualize\" tab to see the radar plot of these samples. And then select the column names/attributes in the legand table." , style = "font-size:14px"),
        p("Right-click on the plot to save the radar plot. Or print it to a PDF file using the Browser's \"print\" button or take a screen shot." , style = "font-size:14px")
      )
    )

# Define UI for random distribution application 
fluidPage(
  tags$head(includeScript("google-analytics.js")),
    
  titlePanel("Oncology Model Fidelity Score"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the
  # br() element to introduce extra vertical spacing
    
  # Show a tabset that includes a plot, summary, and table view
  # of the generated distribution
    tabsetPanel(type = "tabs", 
       tabPanel( "Visualize", Visualize()),
       tabPanel( "Select Study", SelectStudy()),
       tabPanel( "Select Sample", SelectSample()),
       tabPanel( "Upload", Upload()),
       tabPanel( "Tutorials", Tutor() ))
    )
}


