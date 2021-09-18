# 微信小程序倒计时

> 微信小程序短信发送倒计时，基于Taro@2.x React实现。  

###### 使用

```javascript
// 引入
import Timing from '_c/timing'

// 开始方法
startTiming = (start, loading) => {
  loading && loading(true)
  setTimeout(() => {
    start && start()
    loading && loading(false)
  }, 100)
}

// render
<Timing text='188****8888' onClick={this.startTiming} />
```

#### 效果

![效果1](../assets/weapp-sign-3.gif)

> index.jsx  

```javascript
import Taro, { Component } from '@tarojs/taro'
import PropTypes from 'prop-types'
import { View, Text } from '@tarojs/components'
import styles from './timing.module.scss'

/**
 * 倒计时
 */
class Timing extends Component {
  constructor () {
    this.state = {
      clock: 0,
      timer: null,
      loading: false
    }
  }

  componentDidMount () {
    this.setState({ clock: 0 }, this.init)
  }

  componentWillUnmount () {
    const { timer } = this.state
    timer && clearInterval(timer)
  }

  init = () => {
    const { expiresKey, expiresInterval } = this.props
    // 获取上次发送的时间戳
    const time = Taro.getStorageSync(expiresKey)
    if (!time) return
    const now = new Date().getTime()
    // 计算剩余时间
    const surplus = expiresInterval - Math.round((now - +time) / 1000)
    if (surplus <= 0) {
      // 剩余时间不大于零删除失效时间戳
      Taro.removeStorage({ key: expiresKey })
    } else {
      this.setState({ clock: surplus })
      // 开始计时
      const newTimer = setInterval(() => {
        let { timer, clock } = this.state
        if (clock <= 0) {
          timer && clearInterval(timer)
          this.setState({
            clock: 0,
            timer: null
          })
          Taro.removeStorage({ key: expiresKey })
        } else {
          clock--
          this.setState({ clock })
        }
      }, 1000)
      this.setState({ timer: newTimer })
    }
  }

  // 开始计时方法
  startTiming = () => {
    const { expiresKey, expiresInterval } = this.props
    const now = new Date().getTime()
    Taro.setStorage({
      key: expiresKey,
      data: now
    })
    const newTimer = setInterval(() => {
      let { timer, clock } = this.state
      if (clock <= 0) {
        timer && clearInterval(timer)
        this.setState({
          clock: 0,
          timer: null
        })
        Taro.removeStorage({ key: expiresKey })
      } else {
        clock--
        this.setState({ clock })
      }
    }, 1000)
    this.setState({
      clock: expiresInterval,
      timer: newTimer
    })
  }

  // 点击事件处理
  clickHandle = () => {
    const { onClick } = this.props
    const { loading } = this.state
    if (loading) return
    // 通过回调的方式开始计时
    onClick(this.startTiming, l => {
      this.setState({ loading: l })
    })
  }

  render () {
    const { text, buttonText, timingText } = this.props
    const { clock, loading } = this.state
    let content
    if (clock > 0) {
      content = <Text>{clock}{timingText}</Text>
    } else {
      content = <View
        className={[styles.btn, loading && styles.disabled]}
        hoverClass={styles.hover}
        hoverStayTime={100}
        onClick={this.clickHandle}
      >{buttonText}</View>
    }
    return (
      <View className={styles.component}>
        {!!text && <View className={styles.text}>{text}</View>}
        {content}
      </View>
    )
  }
}

Timing.propTypes = {
  text: PropTypes.string,
  buttonText: PropTypes.string,
  timingText: PropTypes.string,
  expiresKey: PropTypes.string,
  expiresInterval: PropTypes.number,
  onClick: PropTypes.func
}

Timing.defaultProps = {
  text: '',
  buttonText: '发送',
  timingText: '秒后重发',
  expiresKey: 'sms_expires',
  expiresInterval: 60,
  onClick: () => { }
}

export default Timing
```

> styles.module.scss  

```css
.component {
  display: inline-flex;
  align-items: center;
  font-size: 28px;
  .btn {
    color: #526BF3;
    &.hover {
      opacity: .6;
    }
    &.disabled {
      color: #CCC;
    }
  }
  text {
    color: #999;
  }
  .text {
    color: #526BF3;
    margin-right: 16px;
  }
}
```
