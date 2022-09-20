create or replace package raul.pkg_ingresos is
  procedure pr_inserta_ingreso(
    pi_id_cliente                 in number,      
    pi_id_tipo_documento_ingreso  in number,
    pi_id_tipo_ingreso            in number,      
    pi_fecha                      in date,        
    pi_mes                        in number,      
    pi_id_tipo_identificacion     in number,   
    pi_identificacion_numero      in varchar2,    
    pi_identificacion_nombre      in varchar2,    
    pi_timbrado_condicion         in varchar2,    
    pi_timbrado_numero            in number,      
    pi_timbrado_documento         in number,      
    pi_cuenta_numero              in varchar2,    
    pi_cuenta_razonsocial         in varchar2,    
    pi_tipo_doc_otros             in varchar2, 
    pi_nro_doc_otros              in varchar2,  
    pi_monto_gravado              in number,      
    pi_monto_no_gravado           in number,      
    pi_monto_total                in number       
  );
end pkg_ingresos;
/
create or replace package body raul.pkg_ingresos is
  procedure pr_inserta_ingreso(
    pi_id_cliente                 in number,               
    pi_id_tipo_documento_ingreso  in number,
    pi_id_tipo_ingreso            in number,          
    pi_fecha                      in date,                    
    pi_mes                        in number,                      
    pi_id_tipo_identificacion     in number,   
    pi_identificacion_numero      in varchar2,    
    pi_identificacion_nombre      in varchar2,    
    pi_timbrado_condicion         in varchar2,       
    pi_timbrado_numero            in number,         
    pi_timbrado_documento         in number,       
    pi_cuenta_numero              in varchar2,            
    pi_cuenta_razonsocial         in varchar2,       
    pi_tipo_doc_otros             in varchar2,     
    pi_nro_doc_otros              in varchar2,      
    pi_monto_gravado              in number,            
    pi_monto_no_gravado           in number,         
    pi_monto_total                in number               
  ) is
    --variables
    v_error varchar2(2000);

    --constantes
    c_tipo_factura number(2) := 17;
    c_tipo_nota_credito number(2) := 18;
    c_tipo_salario number(2) := 19;
    c_tipo_extracto number(2) := 20;
    c_tipo_otros number(2) := 21;

  begin
    --valida items obligatorios
    --montos
    if pi_monto_gravado is null or pi_monto_no_gravado is null or pi_monto_total is null then
      show_error('Favor ingrese los montos del documento.');
    end if;

    --si es factura debe tener condicion
    if pi_id_tipo_documento_ingreso = c_tipo_factura then
      if pi_timbrado_condicion is null then
        show_error('Debe indicar la Condición de la Factura.');
      end if;
    end if;

    --timbrado y numero de documento obligatorios en factura y nota de credito
    if pi_id_tipo_documento_ingreso in (c_tipo_factura, c_tipo_nota_credito) then
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

    --Mes obligatorio para salarios
    if pi_id_tipo_documento_ingreso = c_tipo_salario then
      if pi_mes is null then
        show_error('Debe ingresar el Mes cuando se trata de una Liquidación de Salario.');
      end if;
    end if;


    --inserta en tabla de ingreso
    insert into ingreso values (
      null,                         --id_ingreso se asigna por trigger
      pi_id_cliente,                --cli_id_cliente
      pi_id_tipo_documento_ingreso, --tip_doc_ing_id_tipo_documento_ingreso
      pi_id_tipo_ingreso,           --tip_ing_id_tipo_ingreso
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
      pi_monto_gravado,             --monto_gravado
      pi_monto_no_gravado,          --monto_no_gravado
      pi_monto_total,               --monto_total
      fn_usuario,                   --usuario
      current_date,                 --fecha_grabacion,
      pi_nro_doc_otros              --numero_doc_otros
    );

  end pr_inserta_ingreso;
end pkg_ingresos; 