<?php
/**
 * @package reason
 * @subpackage minisite_templates
 */
	
	/**
	 * Include parent class & dependencies; register module with Reason
	 */
	reason_include_once( 'minisite_templates/modules/default.php' );
	reason_include_once( 'minisite_templates/nav_classes/default.php' );
	include_once( CARL_UTIL_INC . 'dir_service/directory.php' );

	$GLOBALS[ '_module_class_names' ][ basename( __FILE__, '.php' ) ] = 'MaintainedModule';
	
	/**
	 * A minisite module that displays information about who maintains the site & when the page was last updated
	 *
	 * Note that this module uses the Reason site entity to cache the contact information of the primary maintainer.
	 * It does this to avoid potentially expensive directory service lookups on each page hit.
	 *
	 * This cache is renewed each day at 7:00 am, so if the underlying directory information changes during the day,
	 * it won't show up until 7:00 am the next morning.
	 *
	 * @todo Rework to remove reference to the template
	 * @todo Figure out how to reliably report on last modified times if this module is not run last
	 * @todo Use standard Reason caching instead of writing to the site entity
	 * @todo Allow setting of social media view
	 */
	class MaintainedModule extends DefaultMinisiteModule
	{
		var $last_mod_date_format = 'j F Y';
		var $_content;

		function _get_content()
		{
			$format = $this->_get_format();
			if(!empty($format))
			{
				$replacements = array('[[sitename]]'=>'_get_site_name_html','[[maintainer]]'=>'_get_maintainer_html','[[lastmodified]]'=>'_get_last_modified_date_html','[[socialmedialinks]]'=>'_get_social_media_links_html',);
				foreach($replacements as $search=>$function)
				{
					if(strpos($format,$search) === false)
					{
						unset($replacements[$search]);
					}
					else
					{
						$replacements[$search] = $this->$replacements[$search]();
					}
				}
				return str_replace(array_keys($replacements),array_values($replacements),$format);
			}
			return '';
		}
		function has_content()
		{
			if( $this->_get_format() )
				return true;
			else
				return false;
		}
		// Create a footer for a page with an e-mail link to the maintainer and the date it was last modified
		// [updated by footeb on 7/2/03]
		function run()
		{
			$content = $this->_get_content();
			if(!empty($content))
			{
				echo '<div id="maintained">'."\n";
				echo $content;
				echo '</div>'."\n";
			}
		}
		function _get_format()
		{
			$format = '';
			if($this->parent->site_info->get_value('use_custom_footer') == 'yes')
			{
				$format = $this->parent->site_info->get_value('custom_footer');
			}
			else
			{
				if(defined('REASON_DEFAULT_FOOTER_XHTML'))
				{
					$format = REASON_DEFAULT_FOOTER_XHTML;
				}
				else
				{
					trigger_error('REASON_DEFAULT_FOOTER_XHTML needs to be defined in settings/reason_settings.php. Please follow the instructions in the Reason 4 beta 6->beta 7 upgrade script.');
					$format = '<div id="maintainer">[[sitename]] pages maintained by [[maintainer]]</div><div id="lastUpdated">This page was last updated on [[lastmodified]]</div>';
				}
			}
			return $format;
		}
		function _get_site_name_html()
		{
			return $this->parent->site_info->get_value('name');
		}
		function _get_maintainer_html()
		{
			$html = '';
			$pm_values = get_primary_maintainers_of_site($this->site_id);
			
			// make sure we have maintainer values--only go forward if there is one
			if( !empty($pm_values) )
			{
				// build HTML for all primary maintainers
				foreach ($pm_values['users'] as $username => $user_values) {
					
					$full_name = $user_values['full_name'];
					$email = $user_values['email'];
					
					if (!empty($full_name))
					{
						if(!empty($email))
							$html .= '<a href="mailto:'.htmlspecialchars($email,ENT_QUOTES,'UTF-8').'">'.htmlspecialchars($full_name,ENT_QUOTES,'UTF-8').'</a>';
						else
							$html .= $full_name;
					}
					else
					{
						trigger_error('Could not identify site maintainer - check to make sure username - ' . $username . ' - is valid');
						$html .= $username;
					}
					$html .= ', ';
				}
				$html = substr($html, 0, -2); //strip extra comma-space from list
			}
			return $html;
		}
		function _get_last_modified_date_html()
		{
			// munge date into a good looking format
			$date = $this->parent->cur_page->get_value('last_modified');
			
			// ask each module when the entities is contains were most recently modified
			foreach( array_keys($this->parent->_modules) as $key )
			{
				$temp = $this->parent->_modules[$key]->last_modified();
				
				// use the newer date
				if( !empty( $temp ) AND $temp > $date )
					$date = $temp;
			}
			
			return prettify_mysql_timestamp( $date, $this->last_mod_date_format );
		}
		function _get_social_media_links_html()
		{
			reason_include_once('minisite_templates/modules/social_account/models/profile_links.php');
			reason_include_once('minisite_templates/modules/social_account/views/profile_links.php');
			
			/** instantiate and setup the model **/
			$model = new ReasonSocialProfileLinksModel;
			$model->config('site_id', $this->site_id);

			/** instantiate the view **/
			$view = new ReasonSocialProfileLinksView;

			/** setup and run the controller **/
			$controller = new ReasonMVCController($model, $view);
			return $controller->run();
		}
		function get_documentation()
		{
			return '<p>Provides contact information for the primary maintainer of the site and displays the date that the most recently modified item on the page was edited</p>';
		}
	}
?>
