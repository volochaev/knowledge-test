class AddPostVotingProcedure < ActiveRecord::Migration[5.0]
  def up
    connection.execute(%[
      CREATE OR REPLACE FUNCTION add_vote(post int, value int) RETURNS float AS $$
        DECLARE
          new_rating_sum int;
          new_average_rating float;
          rating ratings;
        BEGIN
          IF (value < 1) <> (value > 5) THEN
            RAISE EXCEPTION 'Wrong value for rating update';
          END IF;

          SELECT * INTO rating FROM ratings WHERE ratings.post_id = post;
          IF NOT FOUND THEN
              RAISE EXCEPTION 'Rating entry for post % not found', post;
          END IF;

          new_rating_sum := rating.votes_count + 1;

          CASE
          WHEN value = 1 THEN
            new_average_rating := (1*(rating.one_star_count+1) + 2*rating.two_stars_count + 3*rating.three_stars_count + 4*rating.four_stars_count + 5*rating.five_stars_count)/new_rating_sum::float;
            UPDATE ratings SET one_star_count = (rating.one_star_count + 1) WHERE ratings.post_id = post;
          WHEN value = 2 THEN
            new_average_rating := (1*rating.one_star_count + 2*(rating.two_stars_count+1) + 3*rating.three_stars_count + 4*rating.four_stars_count + 5*rating.five_stars_count)/new_rating_sum::float;
            UPDATE ratings SET two_stars_count = (rating.two_stars_count + 1) WHERE ratings.post_id = post;
          WHEN value = 3 THEN
            new_average_rating := (1*rating.one_star_count + 2*rating.two_stars_count + 3*(rating.three_stars_count+1) + 4*rating.four_stars_count + 5*rating.five_stars_count)/new_rating_sum::float;
            UPDATE ratings SET three_stars_count = (rating.three_stars_count + 1) WHERE ratings.post_id = post;
          WHEN value = 4 THEN
            new_average_rating := (1*rating.one_star_count + 2*rating.two_stars_count + 3*rating.three_stars_count + 4*(rating.four_stars_count+1) + 5*rating.five_stars_count)/new_rating_sum::float;
            UPDATE ratings SET four_stars_count = (rating.four_stars_count + 1) WHERE ratings.post_id = post;
          WHEN value = 5 THEN
            new_average_rating := (1*rating.one_star_count + 2*rating.two_stars_count + 3*rating.three_stars_count + 4*rating.four_stars_count + 5*(rating.five_stars_count+1))/new_rating_sum::float;
            UPDATE ratings SET five_stars_count = (rating.five_stars_count + 1) WHERE ratings.post_id = post;
          ELSE
          END CASE;

          UPDATE ratings SET votes_count = new_rating_sum WHERE ratings.post_id = post;
          UPDATE posts SET weighted_average = new_average_rating WHERE id = post;
          RETURN new_average_rating;
        END;
      $$ LANGUAGE plpgsql VOLATILE
      RETURNS NULL ON NULL INPUT;
    ])
  end

  def down
    connection.execute(%[
      DROP FUNCTION IF EXISTS add_vote(post int, value int);
    ])
  end
end
