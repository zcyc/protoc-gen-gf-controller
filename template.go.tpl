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
func (c *c{{$.Name}}) {{ .HandlerName }}(ctx context.Context, req *v1.{{ .HandlerName }}Req) (res *v1.{{ .HandlerName }}Res, err error) {
	{{if eq .Method "POST" "PUT" "DELETE"}}
	// 调用 service 处理请求
	err := service.{{$.Name}}().{{ .HandlerName }}(ctx, &model.{{ .HandlerName }}Input{
		{{.Request}}:&api.{{.Request}}{

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
	r, err := service.{{$.Name}}().{{ .HandlerName }}(ctx, &model.{{ .HandlerName }}Input{

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