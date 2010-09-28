--Chiara 28/08/2010
CREATE MEMORY TABLE SBI_KPI_DOCUMENTS(ID_KPI_DOC INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,BIOBJ_ID INTEGER NOT NULL,KPI_ID INTEGER NOT NULL,CONSTRAINT SBI_KPI_DOCUMENTS_IBFK_1 FOREIGN KEY(BIOBJ_ID) REFERENCES SBI_OBJECTS(BIOBJ_ID),CONSTRAINT SBI_KPI_DOCUMENTS_IBFK_2 FOREIGN KEY(KPI_ID) REFERENCES SBI_KPI(KPI_ID))

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 08/09/2010: generic user data properties management
CREATE MEMORY TABLE SBI_UDP (UDP_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY, TYPE_ID INTEGER NOT NULL, FAMILY_ID INTEGER NOT NULL, LABEL VARCHAR NOT NULL, NAME VARCHAR NOT NULL, DESCRIPTION VARCHAR NULL,	IS_MULTIVALUE BOOLEAN DEFAULT FALSE, CONSTRAINT FK_SBI_SBI_UDP_1 FOREIGN KEY(TYPE_ID) REFERENCES SBI_DOMAINS(VALUE_ID),	CONSTRAINT FK_SBI_SBI_UDP_2 FOREIGN KEY(FAMILY_ID) REFERENCES SBI_DOMAINS(VALUE_ID));
 
CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL);
CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID);
CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID);
 
CREATE MEMORY TABLE SBI_UDP_VALUE (UDP_VALUE_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,UDP_ID INTEGER NOT NULL, VALUE VARCHAR NOT NULL, PROG INTEGER NULL, LABEL VARCHAR NOT NULL,	NAME VARCHAR NULL, FAMILY VARCHAR NULL, BEGIN_TS TIMESTAMP NOT NULL, END_TS TIMESTAMP NULL, REFERENCE_ID INTEGER NULL, CONSTRAINT FK_SBI_UDP_VALUE_1 FOREIGN KEY(UDP_ID) REFERENCES SBI_UDP(UDP_ID));
 
CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID);

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');
INSERT INTO  SBI_ROLE_TYPE_USER_FUNC values((SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN'), (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'))
COMMIT;


CREATE MEMORY TABLE SBI_KPI_REL (KPI_REL_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,KPI_FATHER_ID INTEGER NOT NULL, KPI_CHILD_ID INTEGER NOT NULL, PARAMETER VARCHAR NULL, CONSTRAINT FK_SBI_KPI_REL_1 FOREIGN KEY(KPI_CHILD_ID) REFERENCES SBI_KPI(KPI_ID), CONSTRAINT FK_SBI_KPI_REL_2 FOREIGN KEY(KPI_FATHER_ID) REFERENCES SBI_KPI(KPI_ID));
CREATE MEMORY TABLE SBI_KPI_ERROR(KPI_ERROR_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,KPI_MODEL_INST_ID INTEGER NOT NULL,USER_MSG VARCHAR(1000) DEFAULT NULL,FULL_MSG VARCHAR DEFAULT NULL,TS_DATE TIMESTAMP DEFAULT NULL, LABEL_MOD_INST VARCHAR(100) DEFAULT NULL,PARAMETERS VARCHAR(1000),CONSTRAINT FK_SBI_KPI_ERROR_MODEL_1 FOREIGN KEY(KPI_MODEL_INST_ID) REFERENCES SBI_KPI_MODEL_INST(KPI_MODEL_INST))


--Delete old Attribute tables
DROP TABLE SBI_KPI_MODEL_ATTR_VAL;
DROP TABLE SBI_KPI_MODEL_ATTR;