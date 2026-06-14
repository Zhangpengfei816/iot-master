package user

import (
	"github.com/gin-gonic/gin"
	"github.com/god-jason/bucket/boot"
	"github.com/god-jason/bucket/web"
)

func init() {
	boot.Register("user", &boot.Task{
		Startup:  Startup,
		Shutdown: nil,
		Depends:  []string{"database", "web"},
	})
}

func Startup() error {

	//鉴权接口
	web.Engine.GET("api/auth", auth)

	web.Engine.POST("api/login", login)

	// OEM 信息，登录页面需要
	web.Engine.GET("api/oem", func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"data": gin.H{
				"name":      "物联大师",
				"logo":      "/assets/logo.png",
				"company":   "无锡真格智能科技有限公司",
				"copyright": "©2016-2024",
			},
		})
	})

	return nil
}
