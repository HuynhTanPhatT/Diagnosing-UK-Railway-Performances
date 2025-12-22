--Exploratory Data Analysis
SELECT	city, route,
		total_train_trips, total_passengers,
		net_revenue, average_price_per_ticket,
		delayed_passengers, cancelled_passengers, refund_revenue,
		on_time_trips, on_time_pct,
		delayed_trips, cancelled_trips
FROM detailed_value_table;
---------------------------------------------------------------------------------

--Each Criterion includes:
---(+) Top group of routes with high revenue, but poor operational (OTP) performance
---(+) Top group of routes with high On-Time Performance Percentage, but high number of delayed and cancelled train trips / passengers.
---(+) Top group of routes with very low revenue and passenger volume, not located in top 3 cities by ticket sales

With ranking_routes_based_on_criterias as (
SELECT	city, route,
		total_train_trips, total_passengers,
		net_revenue, average_price_per_ticket,
		delayed_passengers, cancelled_passengers, refund_revenue,
		on_time_trips, round(cast(replace(on_time_pct,'%','') as float) / 100,3) as otp,
		delayed_trips, cancelled_trips
FROM detailed_value_table
), high_revenue_poor_otp as ( --Top group of routes with high revenue, but poor operational (OTP) performance
SELECT	*,
		ROW_NUMBER() OVER (ORDER BY net_revenue DESC, otp asc) as ranking_high_revenue_poor_otp
FROM ranking_routes_based_on_criterias
where otp < 0.8 --Poor OTP means < 80%, and Average is around 80-90%
), high_otp_poor_delay_cancelled as ( --Top group of routes with high On-Time Performance Percentage, but high number of delayed and cancelled train trips / passengers.
SELECT	*,
		ROW_NUMBER() OVER (ORDER BY cancelled_trips desc, cancelled_passengers desc, delayed_trips desc, delayed_passengers desc) as ranking_high_otp_poor_delay_cancelled
FROM ranking_routes_based_on_criterias
WHERE otp between 0.9 and 0.99  --High OTP means >= 90%
), poor_revenue_passengers as ( --Top group of routes with very low revenue and passenger volume, not located in top 3 cities by ticket sales
SELECT	*,
		ROW_NUMBER() OVER (ORDER BY net_revenue asc, total_passengers asc) as ranking_revenue_contribution
FROM detailed_value_table
WHERE city not in ('London', 'Manchester', 'Liverpool')
)
SELECT	r1.*,
		--r1.city, r1.route,
		h1.ranking_high_revenue_poor_otp, h2.ranking_high_otp_poor_delay_cancelled, p1.ranking_revenue_contribution
FROM ranking_routes_based_on_criterias r1
LEFT JOIN high_revenue_poor_otp h1
	ON r1.route = h1.route
LEFT JOIN high_otp_poor_delay_cancelled h2
	ON r1.route = h2.route
LEFT JOIN poor_revenue_passengers p1
	ON r1.route = p1.route
--where h1.ranking_high_revenue_poor_otp <=3 or h2.ranking_high_otp_poor_delay_cancelled <=3 or p1.ranking_revenue_contribution <=3
ORDER BY h1.ranking_high_revenue_poor_otp asc, h2.ranking_high_otp_poor_delay_cancelled asc, p1.ranking_revenue_contribution asc;








