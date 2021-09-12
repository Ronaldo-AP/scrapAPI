library(plumber)
library(RSelenium)
library(jsonlite)

# Function to prepare data
prepareData <- function (elem) {

    # Get string
    string = elem$getElementText()[[1]]
    # Prepare data
    string = gsub('\\.', '', string)
    # To numeric
    data = as.numeric(string)
    
    return(data)
}

# Connect to remote web driver
remDr <- remoteDriver(remoteServerAddr = "seleniumAddress", port = 4444L)

#* Get COVID-19 statistics
#* @serializer unboxedJSON
#* @post /covid_stats
function (res) {

    # Open remote web driver
    remDr$open()
    # Navigate to web 
    remDr$navigate('https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov/situacionActual.htm')

    # Confirmed cases
    confirmed = list(
        spain = remDr$findElement(value='//p[text()="casos confirmados en España"]//../p[1]'),
        europe = remDr$findElement(value='//p[text()="casos confirmados en Europa"]//../p[1]'),
        world = remDr$findElement(value='//p[text()="casos confirmados en el mundo"]//../p[1]'))

    confirmed = lapply(confirmed, prepareData)

    # Administered doses
    dataVaccines = remDr$findElements(value='//p[@class="dosis-title"]//../p[@class="cifra"]') %>%
        lapply(prepareData) %>% unlist()

    vaccines = list(
        dosesDelivered = dataVaccines[1],
        dosesAdministered = dataVaccines[2],
        completeSchedule = dataVaccines[3]
    )

    # Close remote driver
    remDr$close()

    # Out data
    out = list(confirmedInfections = confirmed, vaccines = vaccines)
}



