cli::cli_h1("web_tool_script_3.R")

devtools::load_all()
use_r_packages()

source("0_global_functions.R")
source("0_web_functions.R")

setup_project()

set_webtool_paths()

options(r2dii_config = file.path(par_file_path, "AnalysisParameters.yml"))

set_global_parameters(file.path(par_file_path, "AnalysisParameters.yml"))

set_portfolio_parameters(file_path = fs::path(par_file_path, paste0(portfolio_name_ref_all, "_PortfolioParameters.yml")))

analysis_inputs_path <- set_analysis_inputs_path(twodii_internal, data_location_ext, dataprep_timestamp)

source(file.path(template_path, "create_interactive_report.R"))
source(file.path(template_path, "create_executive_summary.R"))
source(file.path(template_path, "useful_functions.R"))

report_name = select_report_template(project_code = project_code,
                       language_select = language_select)

exec_summary_name = select_exec_summary_template(project_code = project_code,
                                           language_select = language_select)

template_dir <- paste0(template_path, report_name,"/_book/")
exec_summary_dir <- paste0(template_path, exec_summary_name,"/")

survey_dir <- path(user_results_path, project_code, "survey")
real_estate_dir <- path(user_results_path, project_code, "real_estate")

output_dir <- file.path(outputs_path, portfolio_name_ref_all)

scenario <- "B2DS"
portfolio_allocation_method <- "portfolio_weight"
scenario_geography <- "Global"
audit_file <- read_csv(file.path(proc_input_path, portfolio_name, "audit_file.csv"), col_types = cols())
emissions <- read_rds(file.path(proc_input_path, portfolio_name, "emissions.rda"))

# load equity portfolio data
if (file.exists(file.path(results_path, portfolio_name, "Equity_results_portfolio.rda"))) {
  equity_results_portfolio <- read_rds(file.path(results_path, portfolio_name, "Equity_results_portfolio.rda"))
} else {
  equity_results_portfolio <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "scenario" = NA_character_, "allocation" = NA_character_,
    "equity_market" = NA_character_, "scenario_geography" = NA_character_,
    "year" = NA_integer_, "ald_sector" = NA_character_, "technology" = NA_character_,
    "plan_tech_prod" = NA_integer_, "plan_alloc_wt_tech_prod" = NA_integer_,
    "plan_carsten" = NA_integer_, "plan_emission_factor" = NA_integer_,
    "scen_tech_prod" = NA_integer_, "scen_alloc_wt_tech_prod" = NA_integer_,
    "scen_carsten" = NA_integer_, "scen_emission_factor" = NA_integer_,
    "plan_sec_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "plan_sec_carsten" = NA_integer_, "plan_sec_emissions_factor" = NA_integer_,
    "scen_sec_prod" = NA_integer_, "scen_alloc_wt_sec_prod" = NA_integer_,
    "scen_sec_carsten" = NA_integer_, "scen_sec_emissions_factor" = NA_integer_,
    "plan_tech_share" = NA_integer_, "scen_tech_share" = NA_integer_,
    "trajectory_deviation" = NA_integer_, "trajectory_alignment" = NA_integer_
  )
}

# load bonds portfolio data
if (file.exists(file.path(results_path, portfolio_name, "Bonds_results_portfolio.rda"))) {
  bonds_results_portfolio <- read_rds(file.path(results_path, portfolio_name, "Bonds_results_portfolio.rda"))
} else {
  bonds_results_portfolio <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "scenario" = NA_character_, "allocation" = NA_character_,
    "equity_market" = NA_character_, "scenario_geography" = NA_character_,
    "year" = NA_integer_, "ald_sector" = NA_character_, "technology" = NA_character_,
    "plan_tech_prod" = NA_integer_, "plan_alloc_wt_tech_prod" = NA_integer_,
    "plan_carsten" = NA_integer_, "plan_emission_factor" = NA_integer_,
    "scen_tech_prod" = NA_integer_, "scen_alloc_wt_tech_prod" = NA_integer_,
    "scen_carsten" = NA_integer_, "scen_emission_factor" = NA_integer_,
    "plan_sec_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "plan_sec_carsten" = NA_integer_, "plan_sec_emissions_factor" = NA_integer_,
    "scen_sec_prod" = NA_integer_, "scen_alloc_wt_sec_prod" = NA_integer_,
    "scen_sec_carsten" = NA_integer_, "scen_sec_emissions_factor" = NA_integer_,
    "plan_tech_share" = NA_integer_, "scen_tech_share" = NA_integer_,
    "trajectory_deviation" = NA_integer_, "trajectory_alignment" = NA_integer_
  )
}

# load equity company data
if (file.exists(file.path(results_path, portfolio_name, "Equity_results_company.rda"))) {
  equity_results_company <- read_rds(file.path(results_path, portfolio_name, "Equity_results_company.rda"))
} else {
  equity_results_company <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "scenario" = NA_character_, "allocation" = NA_character_,
    "id" = NA_character_, "company_name" = NA_character_,
    "financial_sector" = NA_character_, "port_weight" = NA_integer_,
    "allocation_weight" = NA_integer_, "plan_br_dist_alloc_wt" = NA_integer_,
    "scen_br_dist_alloc_wt" = NA_integer_,
    "equity_market" = NA_character_, "scenario_geography" = NA_character_,
    "year" = NA_integer_, "ald_sector" = NA_character_, "technology" = NA_character_,
    "plan_tech_prod" = NA_integer_, "plan_alloc_wt_tech_prod" = NA_integer_,
    "plan_carsten" = NA_integer_, "plan_emission_factor" = NA_integer_,
    "scen_tech_prod" = NA_integer_, "scen_alloc_wt_tech_prod" = NA_integer_,
    "scen_carsten" = NA_integer_, "scen_emission_factor" = NA_integer_,
    "plan_sec_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "plan_sec_carsten" = NA_integer_, "plan_sec_emissions_factor" = NA_integer_,
    "scen_sec_prod" = NA_integer_, "scen_alloc_wt_sec_prod" = NA_integer_,
    "scen_sec_carsten" = NA_integer_, "scen_sec_emissions_factor" = NA_integer_,
    "plan_tech_share" = NA_integer_, "scen_tech_share" = NA_integer_,
    "trajectory_deviation" = NA_integer_, "trajectory_alignment" = NA_integer_
  )
}

# load bonds company data
if (file.exists(file.path(results_path, portfolio_name, "Bonds_results_company.rda"))) {
  bonds_results_company <- read_rds(file.path(results_path, portfolio_name, "Bonds_results_company.rda"))
} else {
  bonds_results_company <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "scenario" = NA_character_, "allocation" = NA_character_,
    "id" = NA_character_, "company_name" = NA_character_,
    "financial_sector" = NA_character_, "port_weight" = NA_integer_,
    "allocation_weight" = NA_integer_, "plan_br_dist_alloc_wt" = NA_integer_,
    "scen_br_dist_alloc_wt" = NA_integer_,
    "equity_market" = NA_character_, "scenario_geography" = NA_character_,
    "year" = NA_integer_, "ald_sector" = NA_character_, "technology" = NA_character_,
    "plan_tech_prod" = NA_integer_, "plan_alloc_wt_tech_prod" = NA_integer_,
    "plan_carsten" = NA_integer_, "plan_emission_factor" = NA_integer_,
    "scen_tech_prod" = NA_integer_, "scen_alloc_wt_tech_prod" = NA_integer_,
    "scen_carsten" = NA_integer_, "scen_emission_factor" = NA_integer_,
    "plan_sec_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "plan_sec_carsten" = NA_integer_, "plan_sec_emissions_factor" = NA_integer_,
    "scen_sec_prod" = NA_integer_, "scen_alloc_wt_sec_prod" = NA_integer_,
    "scen_sec_carsten" = NA_integer_, "scen_sec_emissions_factor" = NA_integer_,
    "plan_tech_share" = NA_integer_, "scen_tech_share" = NA_integer_,
    "trajectory_deviation" = NA_integer_, "trajectory_alignment" = NA_integer_
  )
}

# load equity map data
if (file.exists(file.path(results_path, portfolio_name, "Equity_results_map.rda"))) {
  equity_results_map <- read_rds(file.path(results_path, portfolio_name, "Equity_results_map.rda"))
} else {
  equity_results_map <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "ald_location" = NA_character_, "year" = NA_integer_,
    "ald_sector" = NA_character_, "technology" = NA_character_,
    "financial_sector" = NA_character_, "allocation" = NA_character_,
    "allocation_weight" = NA_integer_, "ald_production_unit" = NA_character_,
    "plan_alloc_wt_tech_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "equity_market" = NA_character_, "scenario" = NA_character_,
    "scenario_geography" = NA_character_
  )
}

# load bonds map data
if (file.exists(file.path(results_path, portfolio_name, "Bonds_results_map.rda"))) {
  bonds_results_map <- read_rds(file.path(results_path, portfolio_name, "Bonds_results_map.rda"))
} else {
  bonds_results_map <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "ald_location" = NA_character_, "year" = NA_integer_,
    "ald_sector" = NA_character_, "technology" = NA_character_,
    "financial_sector" = NA_character_, "allocation" = NA_character_,
    "allocation_weight" = NA_integer_, "ald_production_unit" = NA_character_,
    "plan_alloc_wt_tech_prod" = NA_integer_, "plan_alloc_wt_sec_prod" = NA_integer_,
    "equity_market" = NA_character_, "scenario" = NA_character_,
    "scenario_geography" = NA_character_
  )
}

# load equity stress test data
if (file.exists(file.path(results_path, portfolio_name, "Equity_results_stress_test.rda"))) {
  equity_results_stress_test <- read_rds(file.path(results_path, portfolio_name, "Equity_results_stress_test.rda"))
} else {
  equity_results_stress_test <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "ald_sector" = NA_character_, "technology" = NA_character_,
    "scenario_geography" = NA_character_, "VaR_technology" = NA_real_,
    "asset_portfolio_value" = NA_real_, "VaR_Sector" = NA_real_,
    "scenario_name" = NA_character_, "technology_exposure" = NA_real_,
    "ector_exposure" = NA_real_, "sector_loss" = NA_real_,
    "climate_relevant_var" = NA_real_, "portfolio_aum" = NA_real_,
    "portfolio_loss_percentage" = NA_real_, "year_of_shock" = NA_integer_,
    "duration_of_shock" = NA_integer_, "production_shock_percentage" = NA_real_
  )
}

# load bonds stress test data
if (file.exists(file.path(results_path, portfolio_name, "Bonds_results_stress_test.rda"))) {
  bonds_results_stress_test <- read_rds(file.path(results_path, portfolio_name, "Bonds_results_stress_test.rda"))
} else {
  bonds_results_stress_test <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "ald_sector" = NA_character_, "technology" = NA_character_,
    "scenario_geography" = NA_character_, "VaR_technology" = NA_real_,
    "asset_portfolio_value" = NA_real_, "VaR_Sector" = NA_real_,
    "scenario_name" = NA_character_, "technology_exposure" = NA_real_,
    "ector_exposure" = NA_real_, "sector_loss" = NA_real_,
    "climate_relevant_var" = NA_real_, "portfolio_aum" = NA_real_,
    "portfolio_loss_percentage" = NA_real_, "year_of_shock" = NA_integer_,
    "duration_of_shock" = NA_integer_, "production_shock_percentage" = NA_real_
  )
}

# load portfolio overview
if (file.exists(file.path(proc_input_path, portfolio_name, "overview_portfolio.rda"))) {
  portfolio_overview <- read_rds(file.path(proc_input_path, portfolio_name, "overview_portfolio.rda"))
} else {
  portfolio_overview <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "asset_type" = NA_character_, "financial_sector" = NA_character_,
    "valid_input" = NA, "valid_value_usd" = NA_real_,
    "asset_value_usd" = NA_real_, "portfolio_value_usd" = NA_real_
  )
}

# load IPR stress test results
if (file.exists(file.path(results_path, portfolio_name, "Stress_test_results_IPR.rds"))) {
  ipr_results_stress_test <- read_rds(file.path(results_path, portfolio_name, "Stress_test_results_IPR.rds"))
} else {
  ipr_results_stress_test <- tibble(
    "investor_name" = NA_character_, "portfolio_name" = NA_character_,
    "sector" = NA_character_, "subsector" = NA_character_,
    "exposure" = NA_real_, "description" = NA_character_,
    "scenario" = NA_character_, "shock" = NA_real_,
    "loss" = NA_real_
  )
}


indices_equity_results_portfolio <- read_rds(file.path(data_location_ext, "Indices_equity_portfolio.rda"))
indices_bonds_results_portfolio <- read_rds(file.path(data_location_ext, "Indices_bonds_portfolio.rda"))
peers_equity_results_portfolio <- read_rds(file.path(data_location_ext, "Peers_equity_results_portfolio.rda"))
peers_bonds_results_portfolio <- read_rds(file.path(data_location_ext, "Peers_bonds_results_portfolio.rda"))
peers_equity_results_user <- read_rds(file.path(data_location_ext, "Peers_equity_results_portfolio_ind.rda"))
peers_bonds_results_user <- read_rds(file.path(data_location_ext, "Peers_bonds_results_portfolio_ind.rda"))


dataframe_translations <- readr::read_csv(
  path(template_path, "data/translation/dataframe_labels.csv"),
  col_types = cols()
  )

js_translations <- jsonlite::fromJSON(
  txt = path(template_path, "data/translation/js_labels.JSON")
)

shock_year <- 2030 # this should come directly from the stress test.. 2030 based on current discussions in CHPA2020 case

pacta_sectors_not_analysed <- c("Aviation","Cement","Shipping","Steel")
select_scenario = scenario
twodi_sectors = c("Power", "Automotive", "Shipping", "Oil&Gas", "Coal", "Steel", "Cement", "Aviation")
green_techs = c("RenewablesCap", "HydroCap", "NuclearCap", "Hybrid", "Electric", "FuelCell", "Hybrid_HDV", "Electric_HDV", "FuelCell_HDV","Ac-Electric Arc Furnace","Ac-Electric Arc Furnace")
tech_roadmap_sectors = c("Automotive", "Power", "Oil&Gas", "Coal")

display_currency = "CHF"
currency_exchange_value <- 1.03
# TODO: update this from the currencies file

create_interactive_report(
  repo_path = template_path,
  template_dir = template_dir,
  output_dir = output_dir,
  survey_dir = survey_dir,
  real_estate_dir = real_estate_dir,
  language_select = language_select,
  # report_name = report_name,
  project_name = project_name,
  investor_name = investor_name,
  portfolio_name = portfolio_name,
  peer_group = peer_group,
  start_year = start_year,
  shock = shock_year,
  select_scenario = scenario,
  portfolio_allocation_method = portfolio_allocation_method,
  scenario_geography = scenario_geography,
  twodi_sectors = c("Power", "Automotive", "Shipping", "Oil&Gas", "Coal", "Steel", "Cement", "Aviation"),
  green_techs = c("RenewablesCap", "HydroCap", "NuclearCap", "Hybrid", "Electric", "FuelCell", "Hybrid_HDV", "Electric_HDV", "FuelCell_HDV","Ac-Electric Arc Furnace","Ac-Electric Arc Furnace"),
  tech_roadmap_sectors = c("Automotive", "Power", "Oil&Gas", "Coal"),
  pacta_sectors_not_analysed = c("Aviation","Cement","Shipping","Steel"),
  audit_file = audit_file,
  emissions = emissions,
  portfolio_overview = portfolio_overview,
  equity_results_portfolio = equity_results_portfolio,
  bonds_results_portfolio = bonds_results_portfolio,
  equity_results_company = equity_results_company,
  bonds_results_company = bonds_results_company,
  equity_results_map = equity_results_map,
  bonds_results_map = bonds_results_map,
  indices_equity_results_portfolio = indices_equity_results_portfolio,
  indices_bonds_results_portfolio = indices_bonds_results_portfolio,
  peers_equity_results_portfolio = peers_equity_results_portfolio,
  peers_bonds_results_portfolio = peers_bonds_results_portfolio,
  peers_equity_results_user = peers_equity_results_user,
  peers_bonds_results_user = peers_bonds_results_user,
  equity_results_stress_test = equity_results_stress_test,
  bonds_results_stress_test = bonds_results_stress_test,
  dataframe_translations = dataframe_translations,
  js_translations = js_translations,
  ipr_results_stress_test = ipr_results_stress_test,
  display_currency = "CHF",
  currency_exchange_value
)


create_executive_summary(
  file_name = "template.Rmd",
  exec_summary_dir = exec_summary_dir,
  output_dir = file.path(output_dir, "executive_summary"),
  language_select = "EN",
  project_name = "working_dir",
  investor_name = investor_name,
  portfolio_name = portfolio_name,
  peer_group = peer_group,
  start_year = start_year,
  select_scenario = scenario,
  portfolio_allocation_method = portfolio_allocation_method,
  scenario_geography = scenario_geography,
  twodi_sectors = c("Power", "Automotive", "Shipping", "Oil&Gas", "Coal", "Steel", "Cement", "Aviation"),
  green_techs = c("RenewablesCap", "HydroCap", "NuclearCap", "Hybrid", "Electric", "FuelCell", "Hybrid_HDV", "Electric_HDV", "FuelCell_HDV","Ac-Electric Arc Furnace","Ac-Electric Arc Furnace"),
  tech_roadmap_sectors = c("Automotive", "Power", "Oil&Gas", "Coal"),
  alignment_techs = c("RenewablesCap", "CoalCap", "Coal", "Oil", "Gas", "Electric", "ICE"),
  equity_results_portfolio,
  bonds_results_portfolio,
  peers_equity_results_portfolio,
  peers_bonds_results_portfolio
)
