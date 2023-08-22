# 微信小程序日期时间选择器

> 微信小程序日期时间选择器，基于Taro@2.x React实现。  

### 使用

```javascript
// 引入
import DateTimePicker from '_c/datetime-picker'

// 选中确认方法
pickerConfirm = time => {
  this.setState({ time })
}

// render
<DateTimePicker isOpened={isOpened} precision='hour' min={new Date()} onConfirm={this.pickerConfirm} onClose={() => this.setState({ isOpened1: false })} />
```

### 效果

![效果1](../assets/weapp-date-time-picker-1.gif)

> index.jsx  

```javascript
import Taro, { Component } from '@tarojs/taro'
import PropTypes from 'prop-types'
import { View, Text, PickerView, PickerViewColumn } from '@tarojs/components'
import styles from './datetime-picker.module.scss'

/**
 * 时间日期选择器
 */
class DateTimePicker extends Component {
  constructor () {
    this.state = {
      columns: [[], [], [], [], [], []],
      selectIndexList: [0, 0, 0, 0, 0, 0],
      width: '',
      current: null
    }
  }

  componentWillMount () {
    this.init()
  }

  // 计算每列数据
  arrangeColumns = selected => {
    const columns = []
    const { min, max, precision, precisionUnits } = this.props
    // 获取最小年月日时分秒
    const minYear = min.getFullYear()
    const minMonth = min.getMonth() + 1
    const minDay = min.getDate()
    const minHour = min.getHours()
    const minMinute = min.getMinutes()
    const minSecond = min.getSeconds()
    // 获取最大年月日时分秒
    const maxYear = max.getFullYear()
    const maxMonth = max.getMonth() + 1
    const maxDay = max.getDate()
    const maxHour = max.getHours()
    const maxMinute = max.getMinutes()
    const maxSecond = max.getSeconds()

    // 获取精度索引
    const rank = precisionRankRecord[precision]

    // 年-列数据
    if (rank >= precisionRankRecord.year) {
      const years = []
      for (let i = minYear; i <= maxYear; i++) {
        years.push({
          label: precisionUnits.year,
          value: i.toString()
        })
      }
      columns.push(years)
    }

    // 获取选中的年月日时分秒的值
    const selectedYear = parseInt(selected[0])
    const selectedMonth = parseInt(selected[1])
    const selectedDay = parseInt(selected[2])
    const selectedHour = parseInt(selected[3])
    const selectedMinute = parseInt(selected[4])

    // 判断选中的值时分为临界值，小于最小值，大于最大值均属于临界值
    const isInMinYear = selectedYear === minYear
    const isInMaxYear = selectedYear === maxYear
    const isInMinMonth = isInMinYear && selectedMonth <= minMonth
    const isInMaxMonth = isInMaxYear && selectedMonth >= maxMonth
    const isInMinDay = isInMinMonth && selectedDay <= minDay
    const isInMaxDay = isInMaxMonth && selectedDay >= maxDay
    const isInMinHour = isInMinDay && selectedHour <= minHour
    const isInMaxHour = isInMaxDay && selectedHour >= maxHour
    const isInMinMinute = isInMinHour && selectedMinute <= minMinute
    const isInMaxMinute = isInMaxHour && selectedMinute >= maxMinute

    // 月-列数据
    if (rank >= precisionRankRecord.month) {
      const lower = isInMinYear ? minMonth : 1
      const upper = isInMaxYear ? maxMonth : 12
      const months = generateIntArray(lower, upper)
      columns.push(months.map(v => ({
        label: precisionUnits.month,
        value: v.toString()
      })))
    }
    // 日-列数据
    if (rank >= precisionRankRecord.day) {
      // 获取当月天数
      const daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate()
      const lower = isInMinMonth ? minDay : 1
      const upper = isInMaxMonth ? maxDay : daysInMonth
      const days = generateIntArray(lower, upper)
      columns.push(days.map(v => ({
        label: precisionUnits.day,
        value: v.toString()
      })))
    }
    // 时-列数据
    if (rank >= precisionRankRecord.hour) {
      const lower = isInMinDay ? minHour : 0
      const upper = isInMaxDay ? maxHour : 23
      const hours = generateIntArray(lower, upper)
      columns.push(
        hours.map(v => ({
          label: precisionUnits.hour,
          value: v.toString()
        }))
      )
    }
    // 分-列数据
    if (rank >= precisionRankRecord.minute) {
      const lower = isInMinHour ? minMinute : 0
      const upper = isInMaxHour ? maxMinute : 59
      const minutes = generateIntArray(lower, upper)
      columns.push(
        minutes.map(v => ({
          label: precisionUnits.minute,
          value: v.toString()
        }))
      )
    }
    // 秒-列数据
    if (rank >= precisionRankRecord.second) {
      const lower = isInMinMinute ? minSecond : 0
      const upper = isInMaxMinute ? maxSecond : 59
      const seconds = generateIntArray(lower, upper)
      columns.push(
        seconds.map(v => ({
          label: precisionUnits.second,
          value: v.toString()
        }))
      )
    }
    // 返回处理后的列数据
    return columns
  }

  // 初始化
  init = () => {
    const { precision, value, min, max } = this.props
    const length = precisionRankRecord[precision] + 1
    // 根据精度个数，设置每列宽度
    const width = 750 / length
    // 根据输入的value转为选中的日期数组
    const selected = convertDateToStringArray(value)
    // 处理并获取列数据
    const columns = this.arrangeColumns(selected)
    // 根据精度个数，将日期转为yyyyMMddHHmmss格式，需补零
    const selectStr = convertDateToString(value)
    const minStr = convertDateToString(min)
    const maxStr = convertDateToString(max)
    // 处理选中列索引，主要处理临界问题
    let selectIndexList
    if (selectStr <= minStr) {
      // 选中日期小于等于最小日期，默认选中每列第一个
      selectIndexList = [0, 0, 0, 0, 0, 0].slice(0, length)
    } else if (selectStr >= maxStr) {
      // 选中日期大于等于最大日期，默认选中每列最后一个
      selectIndexList = columns.map(column => column.length - 1)
    } else {
      // 选中日期在最小、最大日期区间内，计算内列选中日期的索引位置
      selectIndexList = columns.map((arr, index) => {
        const values = arr.map(item => item.value)
        let idx = values.indexOf(selected[index].toString())
        return idx !== -1 ? idx : 0
      })
    }
    // 设置state数据
    this.setState({ width: `${width}rpx`, current: value, columns, selectIndexList })
  }

  // 滑动选取列change事件处理
  changeHandle = ({ detail }) => {
    // 选中列索引数组
    const { value } = detail
    // 根据选中的列转索引换为选中的值
    const selected = this.getSelectedValueArray(value)
    // 根据选中的列值重新计算列数据
    const columns = this.arrangeColumns(selected)
    // 设置列数据
    this.setState({ columns }, () => {
      // 延时设置临界处理后的列索引
      setTimeout(() => {
        this.setState({ selectIndexList: value })
      }, 1)
    })
  }

  // 滑动式阻止时间冒泡
  handleTouchMove = e => {
    e.stopPropagation()
  }

  // 根据选中的列转索引换为选中的值
  getSelectedValueArray = selectIndexList => {
    const { columns } = this.state
    return columns.map((arr, index) => {
      let idx = selectIndexList[index]
      if (idx > arr.length - 1) {
        idx = arr.length - 1
        selectIndexList[index] = idx
      }
      return arr[idx].value
    })
  }

  // 确认操作
  confirm = () => {
    const { onConfirm, onClose } = this.props
    const { selectIndexList } = this.state
    // 获取选中的值
    const arr = this.getSelectedValueArray(selectIndexList)
    // 转为Date类型
    const date = convertStringArrayToDate(arr)
    // 回调返回
    onConfirm(date)
    // 关闭窗口
    onClose()
  }

  // 根据外层模态框动画结束事件重新初始化
  handleTransitionEnd = () => {
    const { isOpened, value } = this.props
    const { current } = this.state
    // 打开模态框，如果传入的值发生改变，重新初始化，主要处理共用一个时间选择器等特殊情况
    if (isOpened && +(current || 0) !== +(value || 0)) {
      this.init()
    }
  }

  render () {
    const { title, isOpened, onClose } = this.props
    const { columns, selectIndexList, width } = this.state
    return (
      <View
        className={[styles.component, isOpened && styles.active]}
        onTouchMove={this.handleTouchMove}
        onTransitionEnd={this.handleTransitionEnd}
      >
        <View className={styles.overlay} onClick={onClose} />
        <View className={styles.container}>
          <View className={styles.header}>
            <Text className={styles.title}>{title}</Text>
            <View className={styles.confirm} onClick={this.confirm}>确定</View>
          </View>
          <PickerView
            value={selectIndexList}
            className={styles['picker-view']}
            indicatorStyle='height: 50rpx'
            onChange={this.changeHandle}
          >
            {columns.map((arr, index) => <PickerViewColumn
              key={`column_${index}`}
              className={styles['picker-view-column']}
              style={{ width }}
            >
              {arr.map((item, idx) => <View key={`${index}_${idx}`} className={styles.box}>{item.value}{item.label}</View>)}
            </PickerViewColumn>)}
          </PickerView>
        </View>
      </View>
    )
  }
}

// 精度
const precisionRankRecord = {
  year: 0,
  month: 1,
  day: 2,
  hour: 3,
  minute: 4,
  second: 5
}

// 单位
const precisionUnits = {
  year: '年',
  month: '月',
  day: '日',
  hour: '时',
  minute: '分',
  second: '秒'
}

// 当前年
const thisYear = new Date().getFullYear()

DateTimePicker.propTypes = {
  title: PropTypes.string,
  value: PropTypes.instanceOf(Date),
  min: PropTypes.instanceOf(Date),
  max: PropTypes.instanceOf(Date),
  precision: PropTypes.oneOf(Object.keys(precisionRankRecord)),
  precisionUnits: PropTypes.object,
  isOpened: PropTypes.bool,
  onClose: PropTypes.func,
  onConfirm: PropTypes.func
}

DateTimePicker.defaultProps = {
  title: '请选择',
  value: new Date(),
  min: new Date(new Date().setFullYear(thisYear - 10)),
  max: new Date(new Date().setFullYear(thisYear + 10)),
  precision: 'hour',
  precisionUnits,
  isOpened: false,
  onClose: () => {},
  onConfirm: () => {}
}

export default DateTimePicker

// date -> ['2021', '10', '1', '10', '12', '13']
const convertDateToStringArray = date => {
  if (!date) return []
  return [
    date.getFullYear().toString(),
    (date.getMonth() + 1).toString(),
    date.getDate().toString(),
    date.getHours().toString(),
    date.getMinutes().toString(),
    date.getSeconds().toString(),
  ]
}

// ['2021', '10', '1', '10', '12', '13'] -> date
const convertStringArrayToDate = value => {
  if (value.length === 0) return null
  const yearString = value[0] || '1900'
  const monthString = value[1] || '1'
  const dateString = value[2] || '1'
  const hourString = value[3] || '0'
  const minuteString = value[4] || '0'
  const secondString = value[5] || '0'
  return new Date(
    parseInt(yearString),
    parseInt(monthString) - 1,
    parseInt(dateString),
    parseInt(hourString),
    parseInt(minuteString),
    parseInt(secondString)
  )
}

// 根据精度个数，将日期转为yyyyMMddHHmmss格式，需补零
const convertDateToString = (date, length) => {
  return convertDateToStringArray(date).slice(0, length).map(item => {
    let str = item.toString()
    if (str.length < 2) str = str.padStart(2, '0')
    return str
  }).join('')
}

// 指定开始结束值，创建数字数组
const generateIntArray = (from, to) => {
  const array = []
  for (let i = from; i <= to; i++) {
    array.push(i)
  }
  return array
}
```

> datetime-picker.module.scss  

```css
.component {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  visibility: hidden;
  z-index: 777;
  transition: visibility .3s cubic-bezier(0.36, 0.66, 0.04, 1);
  &.active {
    visibility: visible;
    .overlay {
      opacity: 1;
    }
    .container {
      transform: translate3d(0, 0, 0);
    }
  }
  .overlay {
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    position: absolute;
    background-color: rgba(0, 0, 0, .3);
    opacity: 0;
    transition: opacity .15s ease-in;
  }
  .header {
    font-size: 28px;
    height: 78px;
    background-color: #F7F7F7;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
    .title {
      color: #333;
    }
    .confirm {
      position: absolute;
      right: 0;
      top: 0;
      bottom: 0;
      display: flex;
      align-items: center;
      padding: 0 32px;
      color: #536BF3;
    }
  }
  .container {
    position: absolute;
    bottom: 0;
    width: 100%;
    background-color: #FFF;
    transform: translate3d(0, 100%, 0);
    transition: transform .3s cubic-bezier(0.36, 0.66, 0.04, 1);
  }
  .picker-view {
    height: 500px;
    display: flex;
    &-column {
      flex: 1;
      height: 100%;
      width: 150px;
      font-size: 26px;
      .box {
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
      }
    }
  }
}
```
