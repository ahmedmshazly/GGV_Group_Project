CREATE DATABASE GLOBAL_GREEN_VISA;
USE GLOBAL_GREEN_VISA;

CREATE TABLE `GGV_visa_holders` (
  holder_ID varchar(20) NOT NULL,
  first_name varchar(30),
  last_name varchar(30),
  passport_no varchar(10),
  passport_expiry datetime(6),
  email_address varchar(50),
  PRIMARY KEY (holder_ID)
);

CREATE TABLE Participating_Countries (
  country_ID INT NOT NULL,
  country_name varchar(20),
  region varchar(20),
  G_20_Nation BOOLEAN,
  PRIMARY KEY (`country_ID`)
);

CREATE TABLE Partners (
  partner_id varchar(10) NOT NULL,
  organisation_name varchar(20),
  address varchar(100),
  years_in_partnership INT,
  PRIMARY KEY (partner_id)
);

CREATE TABLE Participating_countries_partners (
  PC_ID varchar(10) NOT NULL,
  partner_id varchar(10),
  country_ID INT,
  PRIMARY KEY (PC_ID),
  CONSTRAINT PC_FK FOREIGN KEY(partner_id) REFERENCES Partners(partner_id),
  CONSTRAINT PC_FK1 FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
);

CREATE TABLE GGV_fee_for_participant_countries (
  GGV_fee_ID varchar(10) NOT NULL,
  Country_ID INT,
  fee_for_neighbouring INT,
  fee_for_G20_Nation INT,
  fee_for_non_G20_Nation INT,
  PRIMARY KEY (GGV_fee_ID),
  CONSTRAINT FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
  
);

CREATE TABLE Payment_details (
  payment_ID varchar(20) NOT NULL,
  GGV_fee_ID varchar(10),
  holder_ID varchar(20),
  amount_paid INT,
  QR_code varchar(100),
  preferred_investment Varchar(100),
  payment_date datetime(6),
  payment_expiry_date datetime(6),
  PRIMARY KEY (payment_ID),
  CONSTRAINT PD_FK FOREIGN KEY(GGV_fee_ID) REFERENCES GGV_fee_for_participant_countries(GGV_fee_ID),
  CONSTRAINT PD_FK1 FOREIGN KEY(holder_ID) REFERENCES `GGV_visa_holders`(holder_ID)
  
);

CREATE TABLE Escrow_account (
  escrow_ID varchar(20) NOT NULL,
  country_ID INT,
  PRIMARY KEY (escrow_ID),
  CONSTRAINT EA_FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
  
);

CREATE TABLE Escrow_account_transaction (
  transaction_id varchar(20) NOT NULL,
  payment_ID varchar(20),
  escrow_ID varchar(20),
  PRIMARY KEY (transaction_id),
  CONSTRAINT ET_FK FOREIGN KEY(escrow_ID) REFERENCES Escrow_account(escrow_ID),
  CONSTRAINT ET_FK1 FOREIGN KEY(payment_ID) REFERENCES Payment_details(payment_ID)
);


CREATE TABLE Customer_travel_history (
  cth_ID varchar(20) NOT NULL,
  payment_ID varchar(20),
  arrival_date datetime(6),
  departure_date datetime(6),
  PRIMARY KEY (cth_ID),
  CONSTRAINT CT_FK FOREIGN KEY(payment_ID) REFERENCES Payment_details(payment_ID)
);

CREATE TABLE National_manager (
  manager_ID varchar(5),
  first_name varchar(30),
  last_name varchar(30),
  email_address varchar(50),
  country_ID INT,
  PRIMARY KEY (manager_ID),
  CONSTRAINT NM_FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
  
);
CREATE TABLE trust_fund_country (
  Trust_fund_ID  varchar(10) NOT NULL,
  country_ID INT,
  PRIMARY KEY (Trust_fund_ID ),
  CONSTRAINT TC_FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
  
);


CREATE TABLE Beneficiaries (
  beneficiary_ID varchar(10) NOT NULL,
  name_of_beneficiary Varchar(50),
  beneficiary_type varchar(50),
  amount_allocated INT,
  purpose Varchar(100),
  date_issued datetime(6),
  address Varchar(100),
  Previous_years_budget INT,
  Trust_fund_ID varchar(10),
  PRIMARY KEY (beneficiary_ID),
  CONSTRAINT BC_FK FOREIGN KEY(Trust_fund_ID ) REFERENCES trust_fund_country(Trust_fund_ID )
);

CREATE TABLE Bond (
  bond_ID varchar(10),
  face_value float(8,2),
  maturity_period float(3,2),
  start_date datetime(6),
  end_date datetime(6),
  coupon_rate float(3,2),
  country_ID INT,
  PRIMARY KEY (bond_ID),
  CONSTRAINT B_FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID)
);

CREATE TABLE Investor_bond_buyer(
  investor_ID varchar(10),
  organization Varchar(50),
  first_name Varchar(20),
  last_name Varchar(20),
  address Varchar(100),
  passport_no varchar(10),
  country_of_origin varchar(10),
  PRIMARY KEY (investor_ID)
);

CREATE TABLE Investment_purchase (
  investment_ID varchar(10) not null,
  amount_received INT,
  date_purchased datetime(6),
  bond_ID Varchar(100),
  investor_ID varchar(10),
  Trust_fund_ID  varchar(10),
  PRIMARY KEY (investment_ID),
  CONSTRAINT IP_FK FOREIGN KEY(bond_ID) REFERENCES Bond(bond_ID),
  CONSTRAINT IP_FK1 FOREIGN KEY(investor_ID) REFERENCES Investor_bond_buyer(investor_ID),
  CONSTRAINT IP_FK2 FOREIGN KEY(Trust_fund_ID) REFERENCES trust_fund_country(Trust_fund_ID)
  
);

CREATE TABLE auditors_identification (
  auditor_ID varchar(10) NOT NULL,
  auditor_name Varchar(50),
  PRIMARY KEY (auditor_ID)
);

CREATE TABLE Auditors_for_country (
  ac_ID varchar(10) NOT NULL,
  conservation_results_report varchar(100),
  country_ID INT,
  auditor_ID varchar(10),
  escrow_ID varchar(20),
  PRIMARY KEY (ac_ID),
  CONSTRAINT AC_FK FOREIGN KEY(country_ID) REFERENCES Participating_Countries(country_ID),
  CONSTRAINT AC_FK1 FOREIGN KEY(auditor_ID) REFERENCES auditors_identification(auditor_ID),
  CONSTRAINT AC_FK2 FOREIGN KEY(escrow_ID) REFERENCES Escrow_account(escrow_ID)
  
);

CREATE TABLE Directors(
  director_ID varchar(10),
  first_name Varchar(20),
  last_name Varchar(20),
  Field_of_specialization Varchar(50),
  Years_of_experience INT,
  passport_no varchar(10),
  email_address varchar(50),
  PRIMARY KEY (director_ID)
  );
  
  CREATE TABLE Trust_fund_a_board_manages (
  board_ID varchar(10),
  Trust_fund_ID  varchar(10),
  PRIMARY KEY (board_ID),
  CONSTRAINT TM_FK FOREIGN KEY(Trust_fund_ID) REFERENCES trust_fund_country(Trust_fund_ID)
  
);

CREATE TABLE Board_a_director_belongs_to (
  BD_ID varchar(10),
  board_ID varchar(10),
  director_ID varchar(10),
  PRIMARY KEY (BD_ID),
  CONSTRAINT BD_FK FOREIGN KEY(board_ID) REFERENCES Trust_fund_a_board_manages(board_ID),
  CONSTRAINT BD_FK1 FOREIGN KEY(director_ID) REFERENCES Directors(director_ID)
  );

CREATE TABLE Advisor  (
  advisor_ID varchar(10),
  first_name Varchar(20),
  last_name Varchar(20),
  Field_of_specialization Varchar(50),
  Years_of_experience INT,
  passport_no varchar(10),
  email_address varchar(50),
  PRIMARY KEY (advisor_ID)
);

CREATE TABLE `board_an_advisor's_group_advises` (
  advisor_group_ID varchar(10),
  board_ID varchar(10),
  PRIMARY KEY (advisor_group_ID),
  CONSTRAINT BA_FK FOREIGN KEY(board_ID) REFERENCES Trust_fund_a_board_manages(board_ID)
);

CREATE TABLE `advisor's_group_an_advisor_belongs` (
  AD_ID varchar(10),
  advisor_group_ID varchar(10),
  advisor_ID varchar(10),
  PRIMARY KEY (AD_ID),
  CONSTRAINT AA_FK FOREIGN KEY(advisor_group_ID) REFERENCES `board_an_advisor's_group_advises`(advisor_group_ID),
  CONSTRAINT AA_FK1 FOREIGN KEY(advisor_ID) REFERENCES Advisor(advisor_ID)
);

describe `GGV_visa_holders`;
describe Participating_Countries;
describe Partners;
describe Participating_countries_partners;
describe GGV_fee_for_participant_countries;
describe Payment_details;
describe Escrow_account;
describe Escrow_account_transaction;
describe Customer_travel_history;
describe National_manager;
describe trust_fund_country;
describe Beneficiaries;
describe Bond;
describe Investor_bond_buyer;
describe Investment_purchase;
describe auditors_identification;
describe Auditors_for_country;
describe Directors;
describe Trust_fund_a_board_manages;
describe Board_a_director_belongs_to;
describe Advisor;
describe `board_an_advisor's_group_advises`;
describe `advisor's_group_an_advisor_belongs`;




;