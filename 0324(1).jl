### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 521890de-ab23-11ec-0c2f-2dcaee6dc1bc
using Plots, Distributions, PlutoUI

# ╔═╡ 64e29d20-aaf5-4fa0-ad03-b283dac52dce
md"""
# 3월24일 강의노트
"""

# ╔═╡ 3f43a098-0653-4cb3-a48e-673e342ae48b
Plots.plotly()

# ╔═╡ ddae88bf-0b17-40f4-ae33-5cd70aa8a0de
md"""
### 포아송분포 ($X \sim Poi(\lambda)$)
"""

# ╔═╡ c0e571b7-580a-4b25-ba5b-6cb729ec36b9
md"""
`-` 포아송분포의 요약 
- X의의미: 발생횟수의 평균이 λ인 분포에서 실제 발생횟수를 X라고 한다. 
- X의범위: 발생안할수도 있으므로 X=0이 가능. 따라서 X=0,1,2,3,... 
- parameter의 의미와 범위 : λ = 평균적인 발생횟수; λ>0. 
- pdf: 확률밀도함수
- mgf: 적률생성함수
- E(X): λ
- V(X): λ
"""

# ╔═╡ 7807af0d-012a-432a-9a64-5df4a633333b
md"""
`-` [포아송분포의 예시](https://www.statology.org/poisson-distribution-real-life-examples/#:~:text=Example%201%3A%20Calls%20per%20Hour,receives%2010%20calls%20per%20hour.)
- Calls per Hour at a Call Center
- Number of Arrivals at a Restaurant
- Number of Website Visitors per Hour
- Number of Bankruptcies(파산) Filed per Month
- Number of Network Failures(네트워크 불량) per Week
"""

# ╔═╡ 713fc6aa-3cdb-49ad-903c-9127452e69b9
md"""
`-` 평균이 3인 포아송분포에서 100개의 샘플을 뽑는 방법 
  - 각 sample은 발생횟수를 의미하며 대개 3근처에 분포할 것이다.
  - 발생 횟수이기 때문에 0 혹은 자연수로 뽑힐 것
"""

# ╔═╡ 443fc984-8109-45c3-a6e5-e6e565dd0491
md"""
(방법1) 모듈 이용
"""

# ╔═╡ 6d30adc5-4da9-4e85-bd47-e128de6fffb2
rand(Poisson(3),100)

# ╔═╡ 9a9ed77b-903e-4587-967c-518343a62e54
md"""
(방법2) 이항분포의 포아송근사를 이용 
- 이론: 이항분포에서   (1) $n\to \infty$   (2) $p\to 0$   (3) $np=\lambda$   이면 이것은 평균이 $\lambda$인 포아송분포로 근사함. 
- 평균이 $\lambda$인 포아송분포는 $B(n,\frac{\lambda}{n})$로 근사할 수 있다. 이때 $n$이 커질수록 더 정확해짐. (포아송분포는 평균발생횟수가 λ인 분포에서 실제 발생횟수가 X인 분포)
"""

# ╔═╡ b0ca1c8f-272d-4a2f-ac4b-10bd659fceda
let 
	samplesize_of_poisson = 10000
	λ=3 
	n=100000
	p=λ/n
	X = rand(Binomial(n,p),samplesize_of_poisson)
	# 평균이 λ인 포아송 분포는 B(n,λ/n)로 근사할 수 있다.
	# 즉 위 줄 자체가 평균이 λ인 근사된 포아송 분포에서 sample을 10000개 뽑은 것을 의미
	Y = rand(Poisson(λ),samplesize_of_poisson) # sample 10,000개 뽑기 !
	p1= histogram(X)
	p2= histogram(Y)
	plot(p1,p2,layout=(1,2))
end 

# ╔═╡ 1e943933-7266-4696-9388-6060d0d173e8
md"""
-  $n=10000$ 정도이면 꽤 비슷함. 
- 방법2는 근사방법이므로 엄밀히 말하면 분포를 뽑는 기법이라고 볼 수는 없음. 
"""

# ╔═╡ 4520bf81-0491-4a47-99c4-45680964654c
let 
	λ=3
	n=600 # 커질수록 둘(위와 아래)은 비슷해질 것이다. 
	p=λ/n
	Δt = (60/n) 
	# 예시로서 시간을 1분동안으로 잡았으니까 분자를 60초로 상정하였음
    # 포아송 분포에서 사용하는 건 아니고 아래 markdown 작성시 사용되었음
	
	poi_samplesize = 10000
	X = [(rand(n) .< p) |> sum for k in 1:poi_samplesize]
	p1= histogram(X) # 근사시킨 결과를 histogram에!
	p2= rand(Poisson(λ),poi_samplesize) |> histogram
	_p = plot(p1,p2,layout=(1,2))
	# 2x1 matrix처럼 보여줌	

	md"""
	(방법3) 균등분포 -> 베르누이 -> 이항분포 -> 포아송근사  
	- 개념을 잡아보자
	  - 1분동안 맥도날드에 평균 3명이 온다고 생각하자. 
	  - 이건 사실 1초에 성공확률이 0.05인 베르누이 시행을 1번 시행하여 1분동안 총 60회 반복한 것으로 이해할 수 있음.(60회 반복했으면 이항분포임)
	  - 아니야, 이건 사실 $(Δt) 초에 성공확률이 $p 인 베르누이 시행을 1번 시행하여 1분동안 총 $n 회 반복한 것으로 이해할 수 있음. (베르누이 반복함으로써 -> 이항분포)
	  - 아니야, 이건 사실.... (무한반복)
	    - 뉘앙스 : 즉, 매우 작은 시간에 엄청 작은 확률의 베르누이 시행이 독립적으로 엄청 많이 반복되는 뉘앙스
	$(_p)
	- 위: 유니폼 -> 베르누이 -> 이항분포 -> 포아송(sum까지 시행했을 때 비로소 포아송분포에 근사) 
	- 아래: 포아송
	"""
end 

# ╔═╡ ea7e4bb9-5eca-4046-8209-51489614c636
md"""
(방법4) 균등분포 -> inverse cdf method를 이용해서 생성할 수 있음. 
- 그냥 언급정도만 하신다고 했음
"""

# ╔═╡ 7f765781-47f2-4208-bd91-f549d53c85c6
md"""
---
"""

# ╔═╡ 8352dd50-1f7d-4e3d-9365-5af24d43547c
md"""
### `포아송분포의 합은 다시 포아송분포가 된다`
  - 이론: $X \sim Poi(\lambda_1), Y\sim Poi(\lambda_2),~ X \perp Y (둘이/독립이라면)\Rightarrow X + Y \sim P(\lambda_1 + \lambda_2)$ 
- 의미? (1) 1분동안 맥도날드 매장에 들어오는 남자의 수는 평균이 5인 포아송 분포를 따름 (2) 1분동안 맥도날드 매장에 들어오는 여자의 수는 평균이 4.5인 포아송분포를 따름 (3) 남자와 여자가 매장에 오는 사건은 독립 => 1분동안 맥도날드 매장에 오는 사람은 평균이 9.5인 포아송 분포를 따른다는 의미. 
"""

# ╔═╡ af1c928e-ab6c-4212-88df-e3109503a157
md"""
(실습)
"""

# ╔═╡ 5d376188-fad1-48fb-86a2-7dcc908c337f
let 
	n= 1000
	X = rand(Poisson(5),n)
	Y = rand(Poisson(4.5),n)
	p1 = X.+Y |> histogram 
	# 포아송의 합은 다시 포아송이 된다.
	# broad casting시에, dot은 연산자앞에 붙여준다.
	p2 = rand(Poisson(9.5),n) |> histogram
	plot(p1,p2,layout=(1,2))
end

# ╔═╡ 0ab7a2d2-0d17-4523-8e91-b28624303524
let
	n=1000
	λ=5 
	X = rand(Poisson(λ),n) 
	md"""
	`-` 평균과 분산의 추정 
	- 평균: $λ 
	  - 포아송 분포의 평균은 λ
	- 평균의 추정치: $(mean(X))
	  - 1000개의 sample에 대해서 평균 근사치 구함
	- 분산: $λ 
	  - 포아송 분포의 분산은 λ
	- 분산의 추정치: $(var(X)) 
	  - 1000개의 sample에 대해서 분산 근사치 구함
	"""
end

# ╔═╡ f140fb8e-308f-40e4-a199-b0e0d20dc7da
md"""
- 생각해보니까 왜 평균추정값과 분산추정값이 달라야하나? 
  - 평균추정값들과 분산추정값들을 모아서 히스토그램을 그려보자
"""

# ╔═╡ a222e7a1-dd18-4416-92eb-320f926d1d77
let 
	n = 10000
	λ = 5 
	p1=[mean(rand(Poisson(λ),n)) for k in 1:100] |> histogram
	# 100개의 sample들의 평균 근사치들을 histogram
	p2=[var(rand(Poisson(λ),n)) for k in 1:100] |> histogram
	# 100개의 sample들의 분산 근사치들을 histogram
	p3=[(mean(rand(Poisson(λ),n))+var(rand(Poisson(λ),n))) /2  for k in 1:100] |> histogram 
	# 평균근차치와 분산근사치의 
	
	# 그래도 평균추정이 제일 정확해보인다.(λ에 제일 근접해보인다)
	# 섞어서 p3 만들어봤자 p2가 정확도가 떨어져서 p3도 p1에 비해 좋지 않다.
	# 즉 p2가 제일 평균 λ에 근사한다.
	
	_p=plot(p1,p2,p3,layout=(1,3))
	
    md""" 
	mean(X),var(X)로 λ를 추정
	$(_p)
	"""
end 

# ╔═╡ ebe47018-7a6d-42a4-a61a-0079b5c077f8
md"""
- 히스토그램을 그려보니까 누가봐도 mean(X)로 λ를 추정하는것이 var(X)로 λ를 추정하는것 보다 좋아 보인다. 
- 그냥 mean(X)가 더 추정을 잘 하는 것 같으니 
  - 평균추정량=분산추정량 이라고 주장하면 안되나? => 가능하다! 이게 바로 MLE(최대우도추정량)이다! 
"""

# ╔═╡ 29a2e115-37a7-4f67-a040-a4c1648fdfa6
md"""
### 지수분포 ($X \sim Exp(1/\lambda)$)
"""

# ╔═╡ a185e773-f51e-449b-8d40-de819bd4badf
md"""
`-` 지수분포의 요약 
- X의의미: 단위시간동안 평균 λ번 발생하는 사건이 있을때 첫 번째 이벤트가 발생할때 까지 걸리는 시간.
  - 추가 설명 : 모수가 λ인 푸아송분포는 어떤 사건이 단위시간 동안 평균 λ번 발생하는 것을 묘사하는 분포
  - 추가 설명 : 이 분포에서 한 사건이 일어나고 다음 사건이 일어날 때 걸리는 시간이 따르는 분포가 모수가 λ인 지수분포이다.
  - 추가 설명 : 연속 확률 분포의 일종으로서, 사건이 서로 독립적일 때 일정 시간동안 발생하는 사건의 횟수가 푸아송 분포를 따른다면 next 사건이 일어날 때까지 대기시간은 지수분포를 따른다. 
- X의범위: 시간은 양수이므로 X ≥ 0
- parameter의 의미와 범위: (1) λ = 단위시간에 평균적으로 발생하는 사건의 수 (2) 1/λ = 한번의 이벤트가 발생할때까지 평균적으로 걸리는 시간; 이때, λ>0 
- pdf 확률밀도함수 : $f(x)=\lambda e^{-\lambda x}$ 
- mgf 적률생성함수 : 
- cdf 누적분포함수 : $F(x)=1-e^{-\lambda x}$
- E(X): $\frac{1}{\lambda}$
- V(S): $\frac{1}{\lambda^2}$
"""

# ╔═╡ 885941da-8604-4af0-8b69-6d564348f116
md"""
`-` 평균이 10인 지수분포에서 100개의 샘플을 뽑는 방법 
  - 단위시간동안 평균 발생횟수가 λ인 분포에서 첫번째 이벤트까지 걸리는 시간에 대한 분포
  - 혹은
  - 단위시간동안 평균 발생횟수가 λ인 분포에서 한 사건이 일어나고 다음 사건이 일어날 때 걸리는 시간이 따르는 분포가, 모수가 λ인 지수분포이다. 
"""

# ╔═╡ 2134273b-fca8-4238-b906-f05948fae7d2
md"""
(방법1)
"""

# ╔═╡ 1da1e41d-73a6-43f4-9d69-3e28b83da8e0
rand(Exponential(10),100)

# ╔═╡ caa4ea34-e2ae-455a-88a7-6324ff2cc8ef
md"""
(방법2) 포아송프로세스 -> 지수분포    (역의 관계를 이용해보자)
- 맥도날드에 단위시간당 0.1명씩 평균적으로 방문한다고 해보자
  - 포아송 분포
- 1명 방문하는데에는 평균적으로 시간이 10이 걸린다고 볼 수 있음. 
  - 지수 분포
- 즉 푸아송 분포와 지수분포는 λ가 역의 관계임 
  - 따라서 언뜻생각하면 포아송과 지수분포는 역의 관계라서 포아송분포를 만들고 각 값들의 sample들에 대해서 역수를 취해주면 지수분포를 쉽게 만들 수 있을 것 같다.(사실은 안 됨)
  - 음........ 푸아송에서 λ가 3일 때 X값이 5가 나왔다(단위시간동안 평균 발생횟수가 3인 분포에서 발생횟수가 5가 나왔다면)
  - 그럼, 지수분포(다음 발생이 일어날 때까지 걸리는 x값은)에선 X값이 1/5일 것 
  - 역의 관계는 맞다.
- 포아송 : 발생횟수의 평균이 λ인 실행에서 실제 발생횟수가 X인 분포
- 지수분포 : 단위시간에 평균적으로 λ번 발생하는 사건이 있을 때, 첫 사건이 혹은 다음 사건이 발생하는 데 걸리는 시간
"""

# ╔═╡ eb7572bd-63eb-4792-b982-9f320358a99c
rand(Poisson(0.1),100) 
# 각각의 sample들에 대해 역수를 취하려고 했는데 0이 나오네?
# 푸아송 분포 : 발생횟수가 평균 λ인 분포에서 실제 발생횟수
# 즉 해당 셀에서의 0.1은 평균 발생횟수를 의미.
# 따라서 0이 나올 확률이 높지

# ╔═╡ 1c902aac-d633-4cde-95e1-62e42e0ffe87
md"""
- 각각의 sample들에 대해 역수를 취해주려고 했는데 0이 나온다....?
- 생각해보니까 0이 없다고 쳐도 포아송이 정수로 나와야 하니까 지수분포를 구하기 위해 역수 취한다고 했을 때 나올 수 있는 값은 1, 1/2, 1/3, 1/4, ... 따위임 (애초에 틀린 접근)
  - 왜 틀린 접근?
  - 그리고 추가적으로 Exponential(3)과 Exponential(1/3)은 다른 것인지 같은 것인지
  - 지수 분포 : 단위시간에 평균 λ번 발생하는 사건이 있을 때, 첫 사건이, 혹은 다음 사건이 발생하는 데 거리는 시간.
- 아이디어: 극한의 베르누이로 포아송을 만들때, 몇번 성공했는지 관심을 가지고 카운팅 했음 => 조금 응용해서 첫 성공까지 몇번의 시도를 해야하는지 카운팅을 한다고 생각하면 시간계산이 가능할것 같다. 
- 결국 포아송프로세스 -> 지수분포로 가야함
"""

# ╔═╡ 15cd4e9c-a7f8-4a7b-b1fa-73212186cc97
rand(Exponential(3),10)

# ╔═╡ 3290464e-443b-45f3-b937-ee8d8c6d85ea
rand(Exponential(1/3),10)

# ╔═╡ 5af6dc28-cc63-4836-9e7a-c4eb50873fa9
rand(Poisson(3),10)

# ╔═╡ 56b88fb0-7784-4f2e-a63c-e70bbf2a4cd8
rand(Poisson(1/3),10)

# ╔═╡ 09a0f94b-e90c-4233-933c-7c1237f11658
md"""
(예비학습)
"""

# ╔═╡ 8a1a0dd9-a5fc-4ea1-b026-c47490db1bc3
rand() # 유니폼에서 1개의 샘플 추출 
# rand(1) 이거랑은 살짝 다름(담기는 형태가?)

# ╔═╡ 283ad003-3c0f-4fe6-84e7-1076e65fdde9
rand(1)

# ╔═╡ 011a3508-939b-47b6-a062-9d61c6ea9eec
let 
	i=0 
	while i <= 5
		i=i+1
	end
	i
end

# ╔═╡ aef02ab9-4e12-4030-b428-f4aa36f65ba6
md"""
(풀이시작)
"""

# ╔═╡ c58853fd-9050-4cd8-af4a-afc7f46ca651
md"""
- 첫 성공까지 몇번의 시도를 해야하는지 카운팅을 한다고 생각하면 시간계산이 가능할 것 같다
  - 그래서 아래 셀에서 histogram 그릴 때 델타t를 곱해주는 것!
  - 그래야 첫 성공까지 몇번의 시도를 해야하는지 알 수 있으니.
- histogram은 x값들에 대한 빈도수를 세는 것 !!!
"""

# ╔═╡ e5ac4d16-20ed-4c35-832f-b6fd5cfad2dd
function try_until_you_succeed(p) # 성공 가능할 때까지 시도하는 함수 
	n_of_try=0 
	u=0
	while u < (1-p) # p=0이면 무한반복 
		u = rand()
		n_of_try = n_of_try + 1 
	end
	return n_of_try 
end

# ╔═╡ b0d76b5d-cefa-489e-9963-830d6fb710a0
[try_until_you_succeed(0.1) for k in 1:10000] |> histogram

# ╔═╡ a27efaae-2793-4d8a-8dd6-4900caa80a4a
let 
	exp_samplesize = 10000
	λ=0.1
	n=10000
	p=λ/n
	Δt = (1/n) 
	# 단위시간으로 생각해야 하니까 
	X = [try_until_you_succeed(p) for k in 1:exp_samplesize] .* Δt
	# 연산자 브로드캐스팅시, dot은 연산자 앞에 붙여준다.
	p1 = X|> histogram
	p2 = rand(Exponential(10),exp_samplesize) |> histogram
	plot(p1,p2,layout=(1,2))
end 

# ╔═╡ 829ad68b-7352-4d18-bcfd-90919b18648c
md"""
- 불평: 샘플하나뽑는데 시간이 오래걸림. (정확도를 올릴수록 더 오래걸림)
"""

# ╔═╡ fc1acb74-f856-47c7-b9e1-8d635f0e35ca
md"""
(방법3) inverse cdf method 
- 이론적인 pdf 확률밀도함수를 알고 있다는 전제가 필요함. 
- 자세하게 살펴보자. 
"""

# ╔═╡ c2c198a7-4597-49e2-98d7-8776603db7fa
md"""
##### Inverse cdf method를 활용하여 지수분포에서 샘플추출 
"""

# ╔═╡ cf6a955e-d684-4a16-bc0f-14409f83536a
md"""
`-` 아래와 같은 2개의 지수분포의 pdf를 고려하자.

$$f(x)=e^{-x}$$ 

$$g(x)=\frac{1}{5}e^{-\frac{1}{5}x}$$
"""

# ╔═╡ ed777a37-6351-41a1-aed3-86412c9edaac
md"""
`-` 각각의 pdf를 그려보면 아래와 같다. 
"""

# ╔═╡ db26ed1c-b01a-4f06-886d-4079cf2c139f
let 
	p1= plot(x-> exp(-x), 0, 20)
	p2= plot(x-> 1/5* exp(-x/5),0,20)
	plot(p1,p2,layout=(1,2))
end 

# ╔═╡ 7889eeaa-a7b5-4cdd-8b26-c0de2d2981e0
md"""
`-` 이번에는 각각의 cdf를 그려보자. 

$$F(x)=\int_0^x f(\tau)d\tau=\int_0^x e^{-\tau} d\tau = \left[-e^{-\tau}\right]_0^x=1-e^{-x}$$

$$G(x)=\int_0^x g(\tau)d\tau=\int_0^x \frac{1}{5}e^{-\tau/5} d\tau = \left[-e^{-\tau/5}\right]_0^x=1-e^{-x/5}$$

"""

# ╔═╡ 23abf65d-276d-4a5d-ae70-b41255b35b48
let 
	p1= plot(x -> 1-exp(-x), 0, 20)
	p2= plot(x -> 1-exp(-x/5), 0, 20)
	plot(p1,p2,layout=(2,1))
end 

# ╔═╡ ac1c2222-04b5-4af0-a55c-723b1ad57dec
md"""
`-` cdf 해석 
- 위(평균이1인지수분포) = 5정도면 거의 cdf의 값이 1에 가까워짐 
- 아래(평균이5인지수분포) = 5정도에서 값이 거의 0.63정도임 => 100번뽑으면 5보다 작은게 63개정도.. 

`-` cdf의 y축에서 랜덤변수를 발생시킨다음 $\rightarrow \downarrow$ 와 같이 이동하여 $x$축에 내린다고 생각해보자. (역함수처럼 생각해보기)
- 위: 대부분 5이하에 떨어짐 
- 아래: 약 63% 정도만 5이하에 떨어짐.
"""

# ╔═╡ 9c2f4080-9dd5-4f85-83f7-42bf3c719e6e
# F(x) = 1-exp(-x)
# G(x) = 1-exp(-x/5)
# F: x-> *(-1) -> exp -> *(-1) -> +1 
# Finv: y-> -1 -> *(-1) -> log -> *(-1) 
# G: x-> *(-1/5) -> exp -> *(-1) -> +1
# Ginv : y-> -1 -> *(-1) -> log -> *(-5) 
Finv(x) = -log(-(x-1));Ginv(x) = -5log(-(x-1))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Distributions = "~0.25.52"
Plots = "~1.27.2"
PlutoUI = "~0.7.37"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "c43e992f186abaf9965cc45e372f4693b7754b22"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.52"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "9f836fb62492f4b0f0d3b06f55983f2704ed0883"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a6c850d77ad5118ad3be4bd188919ce97fffac47"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.0+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "4f00cc36fede3c04b8acf9b2e2763decfdcecfa6"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.13"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e8185b83b9fc56eb6456200e873ce598ebc7f262"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.7"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "90021b03a38f1ae9dbd7bf4dc5e3dcb7676d302c"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "6976fab022fea2ffea3d945159317556e5dad87c"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "25405d7016a47cf2bd6cd91e66f4de437fd54a07"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─64e29d20-aaf5-4fa0-ad03-b283dac52dce
# ╠═521890de-ab23-11ec-0c2f-2dcaee6dc1bc
# ╠═3f43a098-0653-4cb3-a48e-673e342ae48b
# ╟─ddae88bf-0b17-40f4-ae33-5cd70aa8a0de
# ╟─c0e571b7-580a-4b25-ba5b-6cb729ec36b9
# ╟─7807af0d-012a-432a-9a64-5df4a633333b
# ╟─713fc6aa-3cdb-49ad-903c-9127452e69b9
# ╟─443fc984-8109-45c3-a6e5-e6e565dd0491
# ╠═6d30adc5-4da9-4e85-bd47-e128de6fffb2
# ╟─9a9ed77b-903e-4587-967c-518343a62e54
# ╠═b0ca1c8f-272d-4a2f-ac4b-10bd659fceda
# ╟─1e943933-7266-4696-9388-6060d0d173e8
# ╠═4520bf81-0491-4a47-99c4-45680964654c
# ╠═ea7e4bb9-5eca-4046-8209-51489614c636
# ╟─7f765781-47f2-4208-bd91-f549d53c85c6
# ╠═8352dd50-1f7d-4e3d-9365-5af24d43547c
# ╟─af1c928e-ab6c-4212-88df-e3109503a157
# ╠═5d376188-fad1-48fb-86a2-7dcc908c337f
# ╠═0ab7a2d2-0d17-4523-8e91-b28624303524
# ╟─f140fb8e-308f-40e4-a199-b0e0d20dc7da
# ╠═a222e7a1-dd18-4416-92eb-320f926d1d77
# ╟─ebe47018-7a6d-42a4-a61a-0079b5c077f8
# ╟─29a2e115-37a7-4f67-a040-a4c1648fdfa6
# ╠═a185e773-f51e-449b-8d40-de819bd4badf
# ╟─885941da-8604-4af0-8b69-6d564348f116
# ╟─2134273b-fca8-4238-b906-f05948fae7d2
# ╠═1da1e41d-73a6-43f4-9d69-3e28b83da8e0
# ╟─caa4ea34-e2ae-455a-88a7-6324ff2cc8ef
# ╠═eb7572bd-63eb-4792-b982-9f320358a99c
# ╠═1c902aac-d633-4cde-95e1-62e42e0ffe87
# ╠═15cd4e9c-a7f8-4a7b-b1fa-73212186cc97
# ╠═3290464e-443b-45f3-b937-ee8d8c6d85ea
# ╠═5af6dc28-cc63-4836-9e7a-c4eb50873fa9
# ╠═56b88fb0-7784-4f2e-a63c-e70bbf2a4cd8
# ╟─09a0f94b-e90c-4233-933c-7c1237f11658
# ╠═8a1a0dd9-a5fc-4ea1-b026-c47490db1bc3
# ╠═283ad003-3c0f-4fe6-84e7-1076e65fdde9
# ╠═011a3508-939b-47b6-a062-9d61c6ea9eec
# ╟─aef02ab9-4e12-4030-b428-f4aa36f65ba6
# ╟─c58853fd-9050-4cd8-af4a-afc7f46ca651
# ╠═e5ac4d16-20ed-4c35-832f-b6fd5cfad2dd
# ╠═b0d76b5d-cefa-489e-9963-830d6fb710a0
# ╠═a27efaae-2793-4d8a-8dd6-4900caa80a4a
# ╟─829ad68b-7352-4d18-bcfd-90919b18648c
# ╟─fc1acb74-f856-47c7-b9e1-8d635f0e35ca
# ╟─c2c198a7-4597-49e2-98d7-8776603db7fa
# ╟─cf6a955e-d684-4a16-bc0f-14409f83536a
# ╟─ed777a37-6351-41a1-aed3-86412c9edaac
# ╠═db26ed1c-b01a-4f06-886d-4079cf2c139f
# ╟─7889eeaa-a7b5-4cdd-8b26-c0de2d2981e0
# ╠═23abf65d-276d-4a5d-ae70-b41255b35b48
# ╟─ac1c2222-04b5-4af0-a55c-723b1ad57dec
# ╠═9c2f4080-9dd5-4f85-83f7-42bf3c719e6e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
