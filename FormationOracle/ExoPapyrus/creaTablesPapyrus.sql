/*Vidage et suppression des tables*/
DROP TABLE VENTE CASCADE CONSTRAINTS;
DROP TABLE ENTCOM CASCADE CONSTRAINTS;
DROP TABLE LIGCOM CASCADE CONSTRAINTS;
DROP TABLE PRODUIT CASCADE CONSTRAINTS;
DROP TABLE FOURNIS CASCADE CONSTRAINTS;
DROP SEQUENCE PRODUIT_CODART;
DROP SEQUENCE ENTCOM_NUMCOM;

/*Creation des sequences*/
CREATE SEQUENCE PRODUIT_CODART
INCREMENT BY 1
START WITH 1
MAXVALUE 9999
MINVALUE 0
NOCYCLE
CACHE 25;
CREATE SEQUENCE ENTCOM_NUMCOM
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999
MINVALUE 0
NOCYCLE
CACHE 25;

/*Creation des tables*/
CREATE TABLE PRODUIT 
(	CODART VARCHAR2(4 BYTE) NOT NULL ENABLE, 
	LIBART VARCHAR2(25 BYTE) NOT NULL ENABLE, 
	STKALE NUMBER(7,0) NOT NULL ENABLE, 
	STKPHY NUMBER(7,0) NOT NULL ENABLE, 
	QTEANN NUMBER(7,0) NOT NULL ENABLE, 
	UNIMES CHAR(5 BYTE) NOT NULL ENABLE, 
	
	CONSTRAINT PK_PRODUIT PRIMARY KEY (CODART)
) ;

 CREATE TABLE FOURNIS 
(	NUMFOU NUMBER(10,0) NOT NULL ENABLE, 
	NOMFOU VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	RUEFOU VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	POSFOU NUMBER(5,0) NOT NULL ENABLE CONSTRAINT CS_FOURNIS_NUMPOST CHECK (POSFOU like ('_____')), 
	VILFOU VARCHAR2(25 BYTE) NOT NULL ENABLE, 
	CONFOU VARCHAR2(15 BYTE) NOT NULL ENABLE, 
	SATISF NUMBER(2,0) CHECK (SATISF <= 10 AND SATISF > 0), 
	
	CONSTRAINT PK_FOURNIS PRIMARY KEY (NUMFOU)
) ;

 CREATE TABLE ENTCOM 
(	NUMCOM NUMBER(10,0) NOT NULL ENABLE, 
	OBSCOM VARCHAR2(30 BYTE), 
	DATCOM DATE DEFAULT (SYSDATE),
    NUMFOU NUMBER(10,0),
	
    CONSTRAINT FK_FOURNIS_NUMFOU FOREIGN KEY (NUMFOU)
		REFERENCES FOURNIS (NUMFOU) ENABLE,
    CONSTRAINT PK_ENTCOM PRIMARY KEY (NUMCOM)
) ;

 CREATE TABLE LIGCOM 
(	NUMCOM NUMBER(10,0) NOT NULL ENABLE,
    NUMLIG NUMBER(10,0) NOT NULL ENABLE, 
    CODART VARCHAR2(4 BYTE) NOT NULL ENABLE,
	QTECDE NUMBER(7,2) NOT NULL ENABLE, 
	PRIUNI NUMBER(7,2) NOT NULL ENABLE,
    QTELIV INTEGER,
    DERLIV NUMBER(7,2) NOT NULL ENABLE,
    
	CONSTRAINT FK_ENTCOM_NUMCOM FOREIGN KEY (NUMCOM)
        REFERENCES ENTCOM (NUMCOM) ENABLE,
    CONSTRAINT FK_PRODUIT_CODART FOREIGN KEY (CODART)
		REFERENCES PRODUIT (CODART) ENABLE,
    CONSTRAINT PK_LIGCOM PRIMARY KEY (NUMCOM, NUMLIG, CODART)
) ;

CREATE TABLE VENTE 
(	CODART VARCHAR2(4 BYTE) NOT NULL ENABLE, 
	NUMFOU NUMBER(10,0) NOT NULL ENABLE, 
	DELLIV NUMBER(6,0) NOT NULL ENABLE, 
	QTE1 NUMBER(6,0) NOT NULL ENABLE, 
	PRIX1 NUMBER(5,2) NOT NULL ENABLE, 
	QTE2 NUMBER(6,0), 
	PRIX2 NUMBER(5,2), 
	QTE3 NUMBER(6,0), 
	PRIX3 NUMBER(5,0), 
	
	CONSTRAINT PK_VENTE PRIMARY KEY (CODART, NUMFOU), 
	CONSTRAINT FK_VENTE_FOURNIS FOREIGN KEY (NUMFOU)
		REFERENCES FOURNIS (NUMFOU) ENABLE, 
	CONSTRAINT FK_VENTE_PRODUIT FOREIGN KEY (CODART)
		REFERENCES PRODUIT (CODART) ENABLE
) ;

/*Creation des indexs*/
CREATE INDEX idx_ENTCOM_NUMFOU
ON ENTCOM(NUMFOU);
