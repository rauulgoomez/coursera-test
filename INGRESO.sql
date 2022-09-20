create table raul.ingreso(
    id_ingreso                              number(20,0) not null, --id x
    cli_id_cliente                          number(20,0) not null, --periodo x, ruc x
    tip_doc_ing_id_tipo_documento_ingreso   number(20,0) not null,--tipo x y tipoTexto x
    tip_ing_id_tipo_ingreso                 number(20,0) not null, --tipoIngreso x ,tipoIngresoTexto x
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
    monto_gravado                           number(20,0) not null, --ingresoMontoGravado x
    monto_no_gravado                        number(20,0) not null, --IngresoMontoNoGravado x
    monto_total                             number(20,0) not null, --ingresoMontoTotal x
    usuario                                 varchar2(10) not null, --interno
    fecha_grabacion                         date not null,--interno
    --FALTA NUMERO DOCUMENTO OTROS
    numero_doc_otros                        varchar2(200) --numeroDocumento x
);
/
alter table raul.ingreso
add constraint ingreso_pk primary key
(id_ingreso )using index;
/
alter table raul.ingreso
add constraint ingreso_cliente_fk foreign key
(cli_id_cliente)
references raul.cliente
(id_cliente);
/
create sequence raul.ingreso_seq
MINVALUE 1 MAXVALUE 9999999999999999999999999999
INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
/
create or replace trigger raul.tr_bi_ingreso_seq
before insert on raul.ingreso
for each row
begin
	if :new.id_ingreso is null then
		select ingreso_seq.nextval into :new.id_ingreso from dual;
	end if;
end;
