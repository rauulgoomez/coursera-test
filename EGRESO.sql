create table raul.egreso(
    id_egreso                               number(20,0) not null, --id x
    cli_id_cliente                          number(20,0) not null, --periodo x, ruc x
    tip_doc_egr_id_tipo_documento_egreso    number(20,0) not null,--tipo y tipoTexto x
    tip_egr_id_tipo_egreso                  number(20,0) not null, --tipoEgreso,tipoEgresoTexto x
    cla_egr_id_clasificacion_egreso         number(20,0) not null, --subtipoEgreso x, subtipoEgresoTexto x 
    fecha                                   date not null,--fecha x
    mes_id_mes                              number(20,0), --mes x
    tip_ide_id_tipo_identificacion          number(20,0) not null, --relacionadoTipoIdentificacion x
    identificacion_numero                   varchar2(200) not null, --relacionadoNumeroIdentificacion x
    identificacion_nombre                   varchar2(2000) not null, --relacionadoNombres x
    timbrado_condicion                      varchar2(20), --timbradoCondicion x
    timbrado_numero                         number(20,0), --timbradoNumero x
    timbrado_documento                      number(20,0), --timbradoDocumento x
    cuenta_numero                           varchar2(200), --cuentaNumero x
    cuenta_razonsocial                      varchar2(200), --cuentaRazonSocial x
    tipo_doc_otros                          varchar2(200), --tipoDocumentoOtros x
    numero_doc_otros                        varchar2(200), --numeroDocumentoOtros x
    numero_despacho                         varchar2(200), --numeroDespacho x
    numero_empleador                        varchar2(200), --empleadorIdentificacion x
    monto_total                             number(20,0) not null, --egresoMontoTotal x
    usuario                                 varchar2(10) not null, --interno
    fecha_grabacion                         date not null--interno
);
/
alter table raul.egreso
add constraint egreso_pk primary key
(id_egreso )using index;
/
alter table raul.egreso
add constraint egreso_cliente_fk foreign key
(cli_id_cliente)
references raul.cliente
(id_cliente);
/
create sequence raul.egreso_seq
MINVALUE 1 MAXVALUE 9999999999999999999999999999
INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
/
create or replace trigger raul.tr_bi_egreso_seq
before insert on raul.egreso
for each row
begin
	if :new.id_egreso is null then
		select egreso_seq.nextval into :new.id_egreso from dual;
	end if;
end;
