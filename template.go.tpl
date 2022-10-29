import (
	"context"
	"errors"

	"github.com/gogf/gf/v2/errors/gcode"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
)

var (
	{{$.Name}} = c{{$.Name}}{}
)

type c{{$.Name}} struct{}

{{range .Methods}}
func (c *c{{$.Name}}) {{ .FunctionName }}(ctx context.Context, req *v1.{{ .FunctionName }}Req) (res *v1.{{ .FunctionName }}Res, err error) {
	{{if eq .Method "POST" "PUT" "DELETE"}}
	// 调用 service 处理请求
	err := service.{{$.Name}}().{{ .FunctionName }}(ctx, &model.{{ .FunctionName }}Input{
		{{ .Request.Name }}:&api.{{ .Request.Name }}{

		},
	})

	// 返回错误消息
	if err != nil {
		return nil, gerror.NewCode(gcode.CodeInternalError, err.Error())
	}

	// 返回成功信息
	g.RequestFromCtx(ctx).Response.WriteJson(&ghttp.DefaultHandlerResponse{
		Code:    gcode.CodeOK.Code(),
		Message: "succeed",
		Data:    nil,
	})
	return
	{{else if eq .Method "GET"}}
	// 调用 service 处理请求
	r, err := service.{{$.Name}}().{{ .FunctionName }}(ctx, &model.{{ .FunctionName }}Input{

	})

	// 返回错误消息
	if err != nil {
		return nil, gerror.NewCode(gcode.CodeInternalError, err.Error())
	}

	// 返回成功信息
	g.RequestFromCtx(ctx).Response.WriteJson(&ghttp.DefaultHandlerResponse{
		Code:    gcode.CodeOK.Code(),
		Message: "succeed",
		Data:    r,
	})
	return
	{{end}}
}
{{end}}