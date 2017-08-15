## 권한 부여 예제

### 사용 gem
```ruby
gem 'devise' # 회원가입 및 회원관리를 용이하게
gem 'cancancan' # 권한 부여
gem 'rolify' # 등급, 역할을 부여
```

### 설치
```
devise 설치
$ rails generate devise:install

devise user model 생성
$ rails generate devise User

cancancan으로 부터 ability 생성
$ rails generate cancan:ability

rolify로 부터 role 생성
$ rails generate rolify Role User

$ rake db:migrate
```

### 권한 부여
```ruby
user.add_role 'admin' # 권한 이름은 마음대로 가능
```

### 권한에 따른 역할 부여
```ruby
# /app/models/board.rb
class Board < ActiveRecord::Base
    resourcify # 이 아이가 있어야 권한에 따른 제어가 가능함
    belongs_to :user
end
```

```ruby
# /app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)

      if user.nil?
        can :read, :all
      elsif user.has_role? 'newbie'
        can [:read, :create], :all
        can [:update, :destroy], Board, user_id: user.id
      elsif user.has_role? 'manager'
        can [:read, :create], :all
        can [:update], all
        can [:destroy], Board, user_id: user.id
      elsif user.has_role? 'admin'
        can [:read, :create, :update, :destroy], :all
      end
  end
```

### 역할에 따른 제어 controller에서 사용
아래 명령어는 각 action에서 제어를 할 때 사용
```ruby
authorize! :write, @board # write 권한이 있는 사람만 들어 올 수 있다
```
아래 명령어를 controller 상단에 추가하면 [:read, :create, :update, :destory] 에 대해서는 자동으로 연결해준다
```ruby
load_and_authorize_resource # 자동으로 [:read, :create, :update, :destory]에 대해서는 index,show new edit destory에 연결해준다

```

### 참고
[devise](https://github.com/plataformatec/devise)
[cancancan](https://github.com/CanCanCommunity/cancancan)
[Devise CanCanCan rolify Tutorial](https://github.com/RolifyCommunity/rolify/wiki/Devise---CanCanCan---rolify-Tutorial)

## 페이징 예제

### 사용 gem
```ruby
gem 'kaminari' # pagination 처리를 위한
```

#### 사용법
사용법은 매우 간단하다.  
다음과 같이 controller와 view에 추가해 주기만 하면  
기본적인 페이징처리는 바로 해준다.
- **controller**
```ruby
@posts = Post.page params[:page]
```
- **view**
```
<% @posts.each do |post| %>
<p><%= post.title%> : <%= post.content%></p>
<% end %>
<%= paginate @posts %>
```
<br/>

**config 변경**
  - page당 25개가 default로 되어있는데 이러한 default 값들을 수정하는 방법은 다음과 같다
```bash
$ rails g kaminari:config
```
- 하면 다음과 같은 파일이 추가되고 여기서 각 종 설정을 변경할 수 있다
```ruby
# config/initializers/kaminari_config.rb

# frozen_string_literal: true
Kaminari.configure do |config|
  config.default_per_page = 5
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.params_on_first_page = false
end
```
```
페이지 당 model 갯수
config.default_per_page = 5

config.max_per_page = nil

현재페이지를 기준으로 양옆에 나오는 숫자 갯수
config.window = 4

 시작과 끝 페이지 보여주는 갯수 1,2 .. 567 .. 9,10
config.outer_window = 0

시작 페이지 보여주는 갯수 1,2 ...
config.left = 2

끝 페이지 보여주는 갯수 ... 8,9,10
config.right = 3

config.page_method_name = :page
config.param_name = :page
config.params_on_first_page = false
```

#### 직접구현
- 간단한 페이징은 사실 직접 구현도 어렵지 않다
- `default_per_page=5` 기준으로 코드를 짜보자면
```ruby
@posts = Post.page(6)
# 은
@posts = Post.offset(25).limit(5)
# 와 같은 역활을 해준다
```

#### locale 설정
- `Rails.root/config/locales`에서 아래와 같은 내용을 수정해주면 된다
- [참고](https://github.com/kaminari/kaminari#i18n-and-labels)
```
en:
  views:
    pagination:
      first: "&laquo; First"
      last: "Last &raquo;"
      previous: "&lsaquo; Prev"
      next: "Next &rsaquo;"
      truncate: "&hellip;"
  helpers:
    page_entries_info:
      one_page:
        display_entries:
          zero: "No %{entry_name} found"
          one: "Displaying <b>1</b> %{entry_name}"
          other: "Displaying <b>all %{count}</b> %{entry_name}"
      more_pages:
        display_entries: "Displaying %{entry_name} <b>%{first}&nbsp;-&nbsp;%{last}</b> of <b>%{total}</b> in total"
```
- 예시
```
views:
  pagination:
    first: "시작"
    last: "마지막"
    previous: "이전"
    next: "다음"
    truncate: "헤헤"
```

### 참고
[kaminari](https://github.com/kaminari/kaminari)
