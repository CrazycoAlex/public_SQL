\connect vis3d postgres
do 
$$
begin
  if not exists (select modelcodeid from classifiersmodel.classifiermodels where modelcodeid = 0)
  then INSERT INTO classifiersmodel.classifiermodels(modelcodeid, name, description) VALUES ( 0, 'Тестовая модель', 'Тестовая, не предназначенная для использования');
  end if;
end 
$$;