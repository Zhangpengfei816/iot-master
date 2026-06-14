package user

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"github.com/god-jason/bucket/api"
	"github.com/god-jason/bucket/config"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type loginObj struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Remember bool   `json:"remember"`
}

func login(ctx *gin.Context) {
	session := sessions.Default(ctx)

	var obj loginObj
	if err := ctx.ShouldBindJSON(&obj); err != nil {
		api.Error(ctx, err)
		return
	}

	var users []*User
	var user *User

	err := _table.Find(bson.D{{"username", obj.Username}}, nil, 0, 1, &users)
	if err != nil {
		api.Error(ctx, err)
		return
	}
	if len(users) == 0 {
		//管理员自动创建
		if obj.Username == "admin" {
			user = &User{
				Name:     "管理员",
				Username: obj.Username,
				Admin:    true,
			}

			idHex, err := _table.Insert(user)
			if err != nil {
				api.Error(ctx, err)
				return
			}
			user.Id, err = primitive.ObjectIDFromHex(idHex)
			if err != nil {
				api.Error(ctx, err)
				return
			}
		} else {
			api.Fail(ctx, "找不到用户")
			return
		}
	} else {
		user = users[0]
	}

	if user.Disabled {
		api.Fail(ctx, "用户已禁用")
		return
	}

	var password Password
	has, err := _passwordTable.Get(user.Id.Hex(), &password)
	if err != nil {
		api.Error(ctx, err)
		return
	}

	//初始化密码
	if !has {
		dp := config.GetString(MODULE, "default_password")
		password.Password = passwordHash(dp)

		//写入数据库。_id 使用与 user 相同的 ObjectID
		_, err = _passwordTable.Insert(map[string]any{
			"_id":      user.Id,
			"password": passwordHash(dp),
		})
		if err != nil {
			api.Error(ctx, err)
			return
		}
	}

	if password.Password != obj.Password {
		api.Fail(ctx, "密码错误")
		return
	}

	//存入session。session 中只保存字符串形式的 ObjectID hex
	session.Set("user", user.Id.Hex())
	_ = session.Save()

	api.OK(ctx, user)
}
