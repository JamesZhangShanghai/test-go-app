package main
import(
	"testing"
	. "github.com/smartystreets/goconvey/convey"
	. "github.com/agiledragon/gomonkey"
)

func Test_GetNameLen_1(t *testing.T) {
    patches := ApplyFunc(findTheUserName,func(_ uint32) string  {
        return "james"
	})
	defer patches.Reset()
	if l := getNameLen(12345); l != 5 {
		t.Error("test failed, the length of name is not correct.", l)
	} else {
		t.Log("test passed.")
	}
}

func Test_GetNameLen_2(t *testing.T) {
	patches := ApplyFunc(findTheUserName,func(_ uint32) string  {
        return ""
	})
	defer patches.Reset()
	if l := getNameLen(0); l != 0 {
		t.Error("test failed, the length of name is not correct.")
	} else {
		t.Log("test passed.")
	}
}

func Test_GetNameLen_3(t *testing.T) {
	patches := ApplyFunc(findTheUserName,func(_ uint32) string  {
        return "test"
	})
	defer patches.Reset()
	if l := getNameLen(1234); l != 4 {
		t.Error("test failed, the length of name is not correct.")
	} else {
		t.Log("test passed.")
	}
}

func Test_GetNameLen_4(t *testing.T) {
	Convey("Test Get name len ",t,func(){
		patches := ApplyFunc(findTheUserName,func(_ uint32) string  {
			return "james"
		})
		defer patches.Reset()
		So(getNameLen(33), ShouldEqual, 5)
	})
}