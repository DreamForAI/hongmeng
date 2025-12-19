@Entry
@Component
struct Index {
  @State result: string[] = ['0']

  setParams(pattern: string) {
    const operators: string = '+-*/.'
    if (this.result.length == 1 && this.result[0] == '0') {
      if ('*/'.includes(pattern)) return
      this.result = [pattern]
    } else {
      const len = this.result.length
      const last = this.result.lastIndexOf('.')
      const slice = this.result.slice(last + 1)
      if (last != -1 && pattern == '.' && /^\d+$/.test(slice.join(''))) return
      if(!(operators.includes(this.result[len-1]) && operators.includes(pattern)))
      {
        this.result.push(pattern)
      }
    }
  }

  calc() {
    let res = 0
    // 注意：match 可能返回 null，建议做非空判断，或者使用空数组兜底
    const dd = this.result.join('').match(/[\-\+]?\d+(\.\d+)?([\/\*]\d+(\.?\d+)?)*/g)

    if (dd) { // 增加非空判断，防止 crash
      dd.forEach(item => {
        if (/^[\+\-]?\d+(\.\d+)?$/.test(item)) {
          // 修改点 1: +item 改为 Number(item)
          res += Number(item)
        } else {
          let rr = 0
          let isj = false
          let operator: string = "*"
          let rrr = item.match(/[\/\*]|(\d+(\.\d+)?)/g)

          if (rrr) { // 同样增加非空判断
            for (let index = 0; index < rrr.length; index++) {
              const element = rrr[index];
              if (element == '-') {
                isj = true
              } else if ('*/'.includes(element)) {
                operator = element
              } else {
                if (rr == 0) {
                  // 修改点 2: +element 改为 Number(element)
                  rr = Number(element)
                  continue
                }
                if (operator == '*') {
                  // 修改点 3: +element 改为 Number(element)
                  rr *= Number(element)
                } else {
                  // 修改点 4: +element 改为 Number(element)
                  rr /= Number(element)
                }
              }
              if (isj) {
                rr = 0 - rr
              }
            }
          }
          res += rr
        }
      })
    }
    this.result = [res + '']
  }

  build() {
    Grid() {
      GridItem() {
        Text(this.result.join(''))
          .padding(10)
          .height('100%')
          .width('100%')
          .fontColor('#fff')
          .textAlign(TextAlign.End)
          .fontSize(50)
      }
      .columnStart(1)
      .columnEnd(4)
      .backgroundColor('#ccc')

      GridItem() {
        Button('CE')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            if (this.result.length == 1) {
              if (this.result[0] == '0') return
              this.result = ['0']
              return
            }
            this.result.pop()
          })
      }

      GridItem() {
        Button('C')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.result = ['0']
          })
      }

      GridItem() {
        Button('/')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('/')
          })
      }
      .backgroundColor('#ccc')

      GridItem() {
        Button('*')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('*')
          })
      }

      // 修复：显式指定 item 类型为 string
      ForEach(['7', '8', '9'], (item: string) => {
        GridItem() {
          Button(item)
            .type(ButtonType.Normal)
            .height('100%')
            .width('100%')
            .backgroundColor('#ccc')
            .onClick(() => {
              this.setParams(item)
            })
        }
      }, (item: string) => item) // 显式指定参数类型，消除 any 警告

      GridItem() {
        Button('-')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('-')
          })
      }

      // 修复：显式指定 item 类型为 string
      ForEach(['4', '5', '6'], (item: string) => {
        GridItem() {
          Button(item)
            .type(ButtonType.Normal)
            .height('100%')
            .width('100%')
            .backgroundColor('#ccc')
            .onClick(() => {
              this.setParams(item)
            })
        }
      }, (item: string) => item) // 显式指定参数类型，消除 any 警告

      GridItem() {
        Button('+')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('+')
          })
      }

      // 修复：显式指定 item 类型为 string
      ForEach(['1', '2', '3'], (item: string) => {
        GridItem() {
          Button(item)
            .type(ButtonType.Normal)
            .height('100%')
            .width('100%')
            .backgroundColor('#ccc')
            .onClick(() => {
              this.setParams(item)
            })
        }
      }, (item: string) => item) // 显式指定参数类型，消除 any 警告

      GridItem() {
        Button('=')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.calc()
          })
      }
      .rowStart(5)
      .rowEnd(6)
      .backgroundColor('#ccc')

      GridItem() {
        Button('0')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('0')
          })
      }
      .columnStart(1)
      .columnEnd(2)

      GridItem() {
        Button('.')
          .type(ButtonType.Normal)
          .height('100%')
          .width('100%')
          .backgroundColor('#ccc')
          .onClick(() => {
            this.setParams('.')
          })
      }
    }
    .columnsGap(10)
    .rowsGap(10)
    .padding(10)
    .rowsTemplate('2fr 1fr 1fr 1fr 1fr 1fr')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .backgroundColor('#ddd')
  }
}