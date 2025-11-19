unit Parameters.BasedParameterStatement;

interface

type
  IParameterContract = interface(IUnknown)
    ['{E1F97C4E-E40A-4283-9F06-0A0B6748274E}']
    (*******************************************************************************
     * 功  能: 实例转为json格式字符串                                              *
     * 参  数: 无                                                                  *
     * 返回值:                                                                     *
     *   返回转换后的标准json格式字符串                                            *
     *******************************************************************************)
    function ToString(): WideString; stdcall;
  end;

implementation

end.
