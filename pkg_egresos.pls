create or replace package raul.pkg_egresos is
  procedure pr_inserta_egreso(
    pi_id_cliente                 in number,      
    pi_id_tipo_documento_egreso   in number,
    pi_id_tipo_egreso             in number,  
    pi_id_clasificacion_egreso    in number,    
    pi_fecha                      in date,        
    pi_mes                        in number,      
    pi_id_tipo_identificacion     in number,   
    pi_identificacion_numero      in varchar2,    
    pi_identificacion_nombre      in varchar2,    
    pi_timbrado_condicion         in varchar2,    
    pi_timbrado_numero            in number,      
    pi_timbrado_documento         in varchar2,      
    pi_cuenta_numero              in varchar2,    
    pi_cuenta_razonsocial         in varchar2,    
    pi_tipo_doc_otros             in varchar2, 
    pi_nro_doc_otros              in varchar2,
    pi_nro_empleador              in varchar2,
    pi_monto_total                in number       
  );
end pkg_egresos;
/
create or replace package body raul.pkg_egresos is
  procedure pr_inserta_egreso(
    pi_id_cliente                 in number,               
    pi_id_tipo_documento_egreso  in number,
    pi_id_tipo_egreso            in number,     
    pi_id_clasificacion_egreso    in number,     
    pi_fecha                      in date,                    
    pi_mes                        in number,                      
    pi_id_tipo_identificacion     in number,   
    pi_identificacion_numero      in varchar2,    
    pi_identificacion_nombre      in varchar2,    
    pi_timbrado_condicion         in varchar2,       
    pi_timbrado_numero            in number,         
    pi_timbrado_documento         in varchar2,       
    pi_cuenta_numero              in varchar2,            
    pi_cuenta_razonsocial         in varchar2,       
    pi_tipo_doc_otros             in varchar2,     
    pi_nro_doc_otros              in varchar2,      
    pi_nro_empleador              in varchar2,    
    pi_monto_total                in number               
  ) is
    --variables
    v_error varchar2(2000);

    --constantes
    c_tipo_factura        number(2) := 4;
    c_tipo_autofactura    number(2) := 5;
    c_tipo_boletaventa    number(2) := 6;
    c_tipo_nota_credito   number(2) := 7;
    c_tipo_salario        number(2) := 8;
    c_tipo_ips            number(2) := 9;
    c_tipo_extracto       number(2) := 10;
    c_tipo_transferencias number(2) := 11;
    c_tipo_exterior       number(2) := 12;
    c_tipo_publico        number(2) := 13;
    c_tipo_ticket         number(2) := 14;
    c_tipo_importacion    number(2) := 15;
    c_tipo_otros          number(2) := 16;

  begin
    --valida items obligatorios
    --montos
    if pi_monto_total is null then
      show_error('Favor ingrese el monto total del egreso.');
    end if;

    --tipo de Identificacion obligatorio si no es IPS
    if pi_id_tipo_documento_egreso != c_tipo_ips
    and (pi_id_tipo_identificacion is null
        or pi_identificacion_numero is null
        or pi_identificacion_nombre is null
        ) then
      show_error('El Tipo de Identificación es obligatorio para este Tipo de Documento.');
    end if;

    --si es factura debe tener condicion
    if pi_id_tipo_documento_egreso = c_tipo_factura
    and pi_timbrado_condicion is null then
      show_error('Debe indicar la Condición de la Factura.');
    end if;

    --timbrado y numero de documento obligatorios en factura y nota de credito
    if pi_id_tipo_documento_egreso in (c_tipo_factura, c_tipo_autofactura, c_tipo_nota_credito, c_tipo_ticket) then
      if pi_timbrado_numero is null or pi_timbrado_documento is null then
        show_error('Debe ingresar el Timbrado y el N° de Documento.');
      end if;

      --validacion de timbrado
      v_error := pkg_gral.fn_valida_timbrado(pi_timbrado_numero);

      --muestra el error
      if v_error is not null then
        show_error(v_error);
      end if;

      --validacion del numero de documento
      v_error := pkg_gral.fn_valida_num_documento(pi_timbrado_documento);

      --muestra el error
      if v_error is not null then
        show_error(v_error);
      end if;
    end if;

    --Para importacion usamos Otros en la pagina
    if pi_id_tipo_documento_egreso = c_tipo_importacion
    and pi_nro_doc_otros is null then
      show_error('Para los Despachos de Importación debe Indifcar el N° de Documento correspondiente.');
    end if;

    --Mes obligatorio para salarios
    if pi_id_tipo_documento_egreso in (c_tipo_salario, c_tipo_ips) then
      if pi_mes is null then
        show_error('Debe ingresar el Mes cuando se trata de una Liquidación de Salario.');
      end if;
    end if;

    --N° del Empleador si es de IPS
    if pi_id_tipo_documento_egreso = c_tipo_ips
    and pi_nro_empleador is null then
      show_error('Para los Extractos de Cuenta de IPS debe indicar el N° del Empleador.');
    end if;

    --Cuentas para Transferencias
    if pi_id_tipo_documento_egreso = c_tipo_transferencias
    and (pi_cuenta_numero is null or pi_cuenta_razonsocial is null) then
      show_error('Para las Transferencias debe indicar el N° de Ceunta y la Razón Social.');
    end if;

    if pi_id_tipo_documento_egreso = c_tipo_otros
    and pi_tipo_doc_otros is null then
      show_error('Para los Otros tipos de documentos, debe indicar el Tipo del mismo.');
    end if;


    --inserta en tabla de egreso
    insert into egreso values (
      null,                         --id_egreso se asigna por trigger
      pi_id_cliente,                --cli_id_cliente
      pi_id_tipo_documento_egreso,  --tip_doc_egr_id_tipo_documento_egreso
      pi_id_tipo_egreso,            --tip_egr_id_tipo_egreso
      pi_id_clasificacion_egreso,   --cla_egr_id_clasificacion_egreso
      pi_fecha,                     --fecha
      pi_mes,                       --mes_id_mes
      pi_id_tipo_identificacion,    --tip_ide_id_tipo_identificacion
      pi_identificacion_numero,     --identificacion_numero
      pi_identificacion_nombre,     --identificacion_nombre
      pi_timbrado_condicion,        --timbrado_condicion
      pi_timbrado_numero,           --timbrado_numero
      pi_timbrado_documento,        --timbrado_documento
      pi_cuenta_numero,             --cuenta_numero
      pi_cuenta_razonsocial,        --cuenta_razonsocial
      pi_tipo_doc_otros,            --tipo_doc_otros
      pi_nro_doc_otros,             --numero_doc_otros
      pi_nro_doc_otros,             --numero_despacho
      pi_nro_empleador,             --numero_empleador
      pi_monto_total,               --monto_total
      fn_usuario,                   --usuario
      current_date                  --fecha_grabacion,
    );

  end pr_inserta_egreso;
end pkg_egresos; 