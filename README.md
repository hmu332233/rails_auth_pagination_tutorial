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
