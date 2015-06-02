
--3) Сравнение разности длин векторов с допустимой ошибкой delta
CREATE OR REPLACE  FUNCTION compare_vector (val_vector double precision[], val_index INTEGER[], delta double precision)
RETURNS INTEGER[] AS
$BODY$
DECLARE
  colname text;
  valueVectorIn double precision;
  valueVectorCur double precision;
  i integer;
  j integer;
  indexCompare integer;
  result INTEGER[];
  id_docBIGINT;
  val_vector_cur double precision[];
  lengthIn double precision;
  lengthCur double precision;
BEGIN

  lengthIn := 0;
  --вычисление длины входного вектора
  FOR i IN 1..array_upper(val_index,1) LOOP
     indexCompare := val_index[i];
     lengthIn := lengthIn + val_vector[indexCompare]*val_vector[indexCompare];
  END LOOP;
  lengthIn := sqrt(lengthIn);
  
  j = 1;
  FOR id_doc IN SELECT values_​​of_the_vectors.id_document FROM values_​​of_the_vectors LOOP -- проход по все таблице
    lengthCur = 0;
colname := 'c1';
    FOR i IN 1..array_upper(val_index, 1) LOOP
     indexCompare := val_index[i];
     valueVectorIn := val_vector[indexCompare];
      EXECUTE 'SELECT '|| quote_ident(colname) || ' FROM values_​​of_the_vectors where id_document=id_doc' INTO valueVectorCur;
     colname:=REPLACE(colname, CAST(i AS CHAR(1)), CAST((i+1) AS CHAR(1)));

     lengthCur := lengthCur + valueVectorCurvalueVectorCur;
     
    END LOOP;
    lengthCur := sqrt(lengthCur);
    
    IF abs(lengthCur - lengthIn)<delta THEN
  result[j] := id_document;
  j := j+1;
    END IF;
  END LOOP;
  
  RETURN result; 
END
$BODY$
LANGUAGE plpgsql;
