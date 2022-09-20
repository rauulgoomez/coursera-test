create or replace package raul.pkg_gral is
  function fn_valida_timbrado(
    pi_timbrado in number
  ) return varchar2;

  function fn_valida_num_documento(
    pi_num_documento in varchar2
  ) return varchar2;

  function fn_devuelve_nro_documento(
    pi_num_documento in number
  ) return varchar2;
end pkg_gral;
/
create or replace package body raul.pkg_gral is
  function fn_valida_timbrado(
    pi_timbrado in number
  ) return varchar2 is
    --variables
    v_error varchar(2000);
  begin
    --debe tener 8 caracteres
    if length(pi_timbrado) != 8 then
      v_error := 'El timbrado debe ser un número de 8 caracteres.';
    end if;

    --retorna el error
    return v_error;
  end fn_valida_timbrado;

  ---------------------------------------------------------------------------------------

  function fn_valida_num_documento(
    pi_num_documento in varchar2
  ) return varchar2 is
    --variables
    v_error varchar(2000);
  begin
    --debe tener 8 caracteres
    if length(pi_num_documento) != 13 then
      v_error := 'El N° de Documento debe ser de 13 caracteres.';
    end if;

    --retorna el error
    return v_error;
  end fn_valida_num_documento;

  ---------------------------------------------------------------------------------------

  function fn_devuelve_nro_documento(
    pi_num_documento in number
  ) return varchar2 is
    v_numero_documento varchar2(20);
    v_return varchar2(20);
  begin
    v_numero_documento := lpad(pi_num_documento,13,'0'); --para que quede 0010010000001

    v_return := substr(v_numero_documento,1,3) || '-' ||  --el 001-
                substr(v_numero_documento,4,3) || '-' ||  --001-001-
                substr(v_numero_documento,7,7);           --001-001-0000001

    return v_return;

  end fn_devuelve_nro_documento;

end pkg_gral;