CREATE DATABASE`regdb`;

CREATE TABLE`user`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '电话',
    # `email` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '电子邮箱',
    `name` VARCHAR(32) NULL COMMENT '名称',
    `gender` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别(0:未知, 1:男, 2:女)',
    `avatar` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '头像',
    `addr` VARCHAR(32) NULL COMMENT '地址',
    CONSTRAINT PRIMARY KEY(`id`),
    CONSTRAINT UNIQUE KEY`user_phone_uni_idx`(`phone`),
    # CONSTRAINT UNIQUE KEY`user_email_uni_idx`(`email`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '用户表';

CREATE TABLE`training_class`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `delete_dt` DATETIME NULL COMMENT '删除时间',
    `name` VARCHAR(32) NOT NULL COMMENT '名称',
    `image` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '图片',
    `reg_fee` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '报名费',
    `description` TEXT NULL COMMENT '描述',
    CONSTRAINT PRIMARY KEY(`id`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '班级表';

CREATE TABLE`dan_wei_pay`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `token` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'token,缴费凭据',
    `class_id` INT UNSIGNED NOT NULL COMMENT '班级id',
    `uid` INT UNSIGNED NOT NULL COMMENT 'user id',
    `dan_wei_name` VARCHAR(32) NOT NULL COMMENT '单位名称',
    `contact_name` VARCHAR(32) NULL COMMENT '联系人名称',
    `contact_phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '联系人电话号码',
    `student_cnt` INT UNSIGNED NOT NULL COMMENT '学员人数',
    `stay_cnt` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '住宿人数',
    `total_fee` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '总费用',
    `pay_money` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '用户支付的金额',
    `balance` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '余额',
    CONSTRAINT PRIMARY KEY(`id`),
    CONSTRAINT UNIQUE KEY`dan_wei_pay_token_uni_idx`(`token`),
    INDEX`dan_wei_pay_class_idx`(`class_id`),
    INDEX`dan_wei_pay_uid_idx`(`uid`),
    CONSTRAINT`dan_wei_pay_class_fkey` FOREIGN KEY`dan_wei_pay_class_fkey_idx`(`class_id`) REFERENCES`training_class`(`id`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '单位缴费表';

CREATE TABLE`reglog`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `class_id` INT UNSIGNED NOT NULL COMMENT '班级id',
    `uid` INT UNSIGNED NOT NULL COMMENT 'user id',
    `name` VARCHAR(32) NOT NULL COMMENT '姓名',
    `gender` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别(0:未知, 1:男, 2:女)',
    `avatar` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '头像',
    `phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '报名时留的电话',
    `email` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '电子邮箱',
    `addr` VARCHAR(32) NULL COMMENT '地址',
    `zhu_su` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否住宿(0:否, 1:是)',
    `bu_men` VARCHAR(32) NULL COMMENT '部门',
    `zhi_wu` VARCHAR(32) NULL COMMENT '职务',
    `dan_wei_name` VARCHAR(32) NULL COMMENT '单位名称',
    `dan_wei_addr` VARCHAR(32) NULL COMMENT '单位地址',
    `zhi_cheng` VARCHAR(32) NULL COMMENT '职称',
    `total_fee` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '总费用',
    `pay_money` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '用户支付的金额',
    `dwp_id` INT UNSIGNED NULL COMMENT '单位缴费id',
    `dwp_pay_dt` DATETIME NULL COMMENT '用户使用单位缴费凭证支付时间,同dwp_id一起写入',
    CONSTRAINT PRIMARY KEY(`id`),
    INDEX`reglog_class_idx`(`class_id`),
    INDEX`reglog_uid_idx`(`uid`),
    CONSTRAINT UNIQUE KEY`reglog_class_user_uni_idx`(`class_id`, `uid`),
    CONSTRAINT`reglog_class_fkey` FOREIGN KEY`reglog_class_fkey_idx`(`class_id`) REFERENCES`training_class`(`id`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '报名登记表';

CREATE TABLE`invoice_apply`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `uid` INT UNSIGNED NOT NULL COMMENT 'user id',
    `phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '申请发票时留的电话',
    `business` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '' COMMENT '申请发票的业务',
    `bid` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '和业务对应的id',
    `dan_wei_name` VARCHAR(32) NULL COMMENT '单位名称',
    `buyer_type` TINYINT DEFAULT NULL COMMENT '开票对象个人=0,公司=1',
    `invoice_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票类型(0:普票, 1:专票)',
    `invoice_title` VARCHAR(32) NULL COMMENT '发票抬头',
    `tax_num` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '税号',
    `bank` VARCHAR(32) NULL COMMENT '开户银行',
    `bank_account` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '开户银行账号',
    `kaifapiao_dt` DATETIME NULL COMMENT '开发票时间,后台标记这个发票申请开了发票时的时间就录如成了这个字段的值,所以这个字段记录的开发票时间不一定就真的是开发票给这个发票申请的用户的时间[因为开发票是一个线下操作]',
    `kaifapiao_adm_uid` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '后台标记这个发票申请开了发票的后台用户id',
    # `kaifapiao_adm_user` TEXT NULL COMMENT 'json格式,后台标记这个发票申请开了发票的后台用户快照',
    `memo` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '备注',
    CONSTRAINT PRIMARY KEY(`id`),
    INDEX`invoice_apply_uid_idx`(`uid`),
    INDEX`invoice_apply_phone_idx`(`phone`),
    INDEX`invoice_apply_bid_idx`(`bid`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '发票申请表';

CREATE TABLE`signinlog`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `class_id` INT UNSIGNED NOT NULL COMMENT '班级id',
    `uid` INT UNSIGNED NOT NULL COMMENT 'user id',
    `name` VARCHAR(32) NOT NULL COMMENT '名称',
    `gender` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '性别(0:未知, 1:男, 2:女)',
    `phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '签到时留的电话',
    `dan_wei_name` VARCHAR(32) NULL COMMENT '单位名称',
    `faziliao_dt` DATETIME NULL COMMENT '发资料时间,后台标记这个签到发了资料时的时间就录如成了这个字段的值,所以这个字段记录的发资料时间不一定就真的是把资料发给这个签到用户的时间[因为发资料是一个线下操作]',
    `faziliao_adm_uid` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '后台标记这个签到发了资料的后台用户id',
    # `faziliao_adm_user` TEXT NULL COMMENT 'json格式,后台标记这个签到发了资料的后台用户快照',
    CONSTRAINT PRIMARY KEY(`id`),
    INDEX`signinlog_class_idx`(`class_id`),
    INDEX`signinlog_uid_idx`(`uid`),
    CONSTRAINT UNIQUE KEY`signinlog_class_user_uni_idx`(`class_id`, `uid`),
    CONSTRAINT`signinlog_class_fkey` FOREIGN KEY`signinlog_class_fkey_idx`(`class_id`) REFERENCES`training_class`(`id`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '签到表';

CREATE TABLE`admin_user`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL,
    `phone` VARCHAR(15) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '电话',
    `email` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '电子邮箱',
    `password` CHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT 'md5后的密码',
    `nickname` VARCHAR(32) NOT NULL COMMENT '昵称',
    `avatar` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '头像',
    CONSTRAINT PRIMARY KEY(`id`),
    CONSTRAINT UNIQUE KEY`phone_uni_idx`(`phone`),
    CONSTRAINT UNIQUE KEY`email_uni_idx`(`email`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '后台用户表';

CREATE TABLE`admin_menu`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pid` INT UNSIGNED NULL COMMENT '父级id',
    `level` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'level',
    `priority` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'priority',
    `type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '菜单类型(0:菜单, 1:菜单组, 2:隐式菜单),菜单组可以包含菜单组和菜单和隐式菜单,菜单和隐式菜单只能包含隐式菜单,否则页面菜单栏可能有问题',
    `icon` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT 'icon',
    `icon_color` VARCHAR(8) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT 'icon color',
    `name` VARCHAR(32) NOT NULL COMMENT '名称',
    `methods` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'http method [or] union(0b00000001:GET, 0b00000010:POST, 0b00000100:PUT, 0b00001000:DELETE, 0b00010000:HEAD, 0b00100000:OPTIONS),非隐式菜单 method 只能是GET,因为非隐式菜单会出现在页面菜单栏中',
    `path` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT 'url path',
    CONSTRAINT PRIMARY KEY(`id`),
    CONSTRAINT`admin_menu_pid_foreign_key` FOREIGN KEY`admin_menu_pid_foreign_key_idx`(`pid`) REFERENCES`admin_menu`(`id`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '后台菜单表';

CREATE TABLE`payorder`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `orderno` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '支付订单号,专门用于支付,给到支付宝或者微信支付等支付商',
    `create_dt` DATETIME NOT NULL COMMENT '创建时间',
    `uid` INT UNSIGNED NOT NULL COMMENT 'user(id),冗余字段,方便查询',
    `business` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '业务',
    `bid` INT UNSIGNED NOT NULL COMMENT '和业务对应的id',
    `amount` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '支付订单金额',
    `pay_type` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '支付类型(alipay:支付宝支付, wxpay:微信支付, wxpay_mweb:微信支付h5支付),创建payorder时就要确定pay_type',
    `prepay_id` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '预支付交易会话标志,用于后续支付商接口调用中使用',
    `pay_uri` VARCHAR(256) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '支付链接(alipay:支付二维码链接, wxpay:支付二维码链接, wxpay_mweb:支付跳转链接),同prepay_id一起写入',
    `prepay_expire_dt` DATETIME NULL COMMENT '预支付交易过期时间,即 prepay_id 过期时间,同prepay_id一起写入',
    `pay_first_notify_dt` DATETIME NULL COMMENT '第1次收到支付回调通知时记录下来,证明收到过支付回调通知,不代表支付成功也不代表我方处理支付回调成功',
    `pay_first_log` TEXT NULL COMMENT 'json格式,记录第1次收到支付回调通知信息的快照',
    `pay_success_dt` DATETIME NULL COMMENT '我方成功处理支付回调通知的时间,成功修改了和这个支付订单相关的业务的数据',
    `pay_dt` DATETIME NULL COMMENT '用户支付时间,有可能用户支付很久后我方才收到通知,如果支付回调通知中携带了用户支付时间,则本字段就等于用户支付时间,否则本字段等于支付回调通知时间,同pay_success_dt一起写入',
    `pay_trade_no` VARCHAR(64) CHARACTER SET ascii COLLATE ascii_general_ci NULL COMMENT '支付交易号,一般退款的时候需要用到,同pay_success_dt一起写入',
    `pay_log` TEXT NULL COMMENT 'json格式,记录支付回调通知信息的快照,同pay_success_dt一起写入',
    `refund_request_dt` DATETIME NULL COMMENT '发起退款时间',
    `refund_done_dt` DATETIME NULL COMMENT '退款完成时间,收到退款完成通知时直接写入,再来修改业务数据,如果业务中发现业务数据和这里的退款不匹配了,请修复业务数据',
    `refund_log` TEXT NULL COMMENT 'json格式,记录退款完成通知信息的快照,同refund_done_dt一起写入',
    CONSTRAINT PRIMARY KEY(`id`),
    CONSTRAINT UNIQUE KEY`payorder_orderno_uni_idx`(`orderno`),
    INDEX`payorder_uid_idx`(`uid`),
    INDEX`payorder_bid_idx`(`bid`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '支付订单表,1个业务订单可以对应n个支付订单';

CREATE TABLE`smslog`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `create_dt` DATETIME NOT NULL COMMENT '创建时间',
    `uid` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'user id',
    `send_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送类型(1:登陆)',
    `provider` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '' COMMENT '短信服务商',
    `account` VARCHAR(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '' COMMENT '发这条短信使用的账号,账号是短信服务商提供给我们调用他们的接口时使用的,有的账号有子账号,为了区分,记录一下账号',
    `phone` VARCHAR(16) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT '手机号',
    `content` VARCHAR(512) NOT NULL COMMENT '短信内容',
    `response` TEXT NULL COMMENT 'json格式,调用短信服务商的接口的返回结果',
    CONSTRAINT PRIMARY KEY(`id`),
    INDEX`smslog_uid_idx`(`uid`),
    INDEX`smslog_phone_idx`(`phone`)
) ENGINE = InnoDB, DEFAULT CHARACTER SET = utf8, DEFAULT COLLATE = utf8_general_ci, COMMENT = '发送短信日志表';