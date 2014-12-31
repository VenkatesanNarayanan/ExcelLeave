(function($){
	
	Plugin.prototype ={
		
		defaults : 
		{
			'optionlist' : [],
			'selectedlist' : [],
			'height' : 0,
			'width' : 0,
		},
	};

	var method = {
		appendoptionlist : function($obj,list)
		{
			appendlistitems($obj,'#lp_chooseitems',list);
		},
		appendselectedlist : function($obj,list)
		{
			appendlistitems($obj,'#lp_chooseditems',list);
		},

		resetoption: function($obj,list)
		{
			if(list.optionlist)
			{
				additems($obj,'#lp_chooseitems',list.optionlist);
			}
			if(list.selectedlist)
			{
				additems($obj,'#lp_chooseditems',list.selectedlist);
			}
			if(list.height)
			{
				$obj.find('.lp_height').css({'height' : list.height});
			}
			if(list.width)
			{
				$obj.find('.lp_list').css({'width' : list.width});
			}
		},
		getchooseditems : function($obj,list)
		{
			var chooseditems = [];
			$obj.find('#lp_chooseditems option').map(function(){
				chooseditems.push(this.value);
			});
			return chooseditems;
		},
	};
	
	function additems($control,element,list)
	{
		var uniquearray = [];
		var temp;
		var $element_obj = $control.find(element);
		$control.find(element + ' option').remove();
		if (element == '#lp_chooseitems')
		{
			$.each(list, function(index,value)
			{
				if(typeof value != 'number')
					temp = value.toLowerCase();
				else	
					temp = value.toString();
				if($.inArray(temp,uniquearray) === -1)
				{ 
					uniquearray.push(temp);
					$element_obj.append('<option value="' +value+ '">' + value + '</option>');	
				}
			});
		}
		else
		{
			$.each(list, function(index,value)
			{
				if(typeof value != 'number')
					temp = value.toLowerCase();
				else	
					temp = value.toString();
				if($.inArray(temp,uniquearray) === -1)
				{
					$control.find('#lp_chooseitems option[value ="' + value + '"]').remove(); 
					uniquearray.push(temp);
					$element_obj.append('<option value="' +value+ '">' + value + '</option>');	
				}
			});

		}
	}
	
	function appendlistitems($control,element,list)
	{
		var chooseditems = $control.find('#lp_chooseditems option').map(function(){
			return this.value;
		});
		

		var uniquearray = [];
		var temp;
		var $element_obj = $control.find(element);

		if(element == '#lp_chooseitems')
		{
			var chooseitems = $control.find('#lp_chooseitems option').map(function(){
				return this.value;
			});
			$.each(list,function(index, value)
			{
				if (typeof value != 'number')
					temp = value.toLowerCase();
				else
					temp = value.toString();

				if($.inArray(temp, uniquearray) === -1 && $.inArray(temp,chooseitems) === -1 && $.inArray(temp,chooseditems) === -1)
				{
					uniquearray.push(temp);
					$element_obj.append('<option value="' +value+ '">' + value + '</option>');
				}
			});
		}
		else
		{
			$.each(list,function(index, value)
			{
				if (typeof value != 'number')
					temp = value.toLowerCase();
				else
					temp = value.toString();

				if($.inArray(temp, uniquearray) === -1 && $.inArray(temp,chooseditems) === -1  )
				{
					$control.find('#lp_chooseitems option[value="'+ value +'"]').remove();
					uniquearray.push(temp);
					$element_obj.append('<option value="' +value+ '">' + value + '</option>');
				}
			});

		}
	};

	$.fn.ListPicker = function(options)
	{
		if(arguments[0] == 'option')
		{
			return method['resetoption'].apply(this,[this,arguments[1]]);
		}
		else if (method[options])
		{
		     
			return method[options].apply(this,[this,arguments[1]]);
		    
		}
		else
		{
			return this.each(function()
			{
				new Plugin(this,options).init();
			});
		}
	};

	function Plugin(element, options)
	{
		var $lp_scope = this;
		$lp_scope.$element = $(element);
		$lp_scope.options = $.extend({}, this.defaults, options);
		$lp_scope.init = function()
		{
			var $lp_controls =$(
								'<div class="lp_root">'
									+'<div class="lp_selectlistdiv lp_height">'
										+'<select id="lp_chooseitems" name="lp_chooselist" multiple="multiple" class="lp_list" ></select>'
									+'</div>'
									+'<div class="lp_height lp_buttondiv">'
										+'<div id="lp_choosebtndiv"  name = "lp_choosediv" class="lp_choosebuttondiv">'
											+'<input type="button" id="lp_choose" class="lp_choosebutton" value="&gt">'
										+'</div>'
										+'<div id="lp_unchoosebtndiv" class="lp_unchoosebuttondiv">'
											+'<input type="button" id="lp_unchoose" class="lp_unchoosebutton" value="&lt">'
										+'</div>'
									+'</div>'
									+'<div class="lp_selectedlistdiv lp_height">'
										+'<select id="lp_chooseditems" name="lp_choosedlist" multiple="multiple" class="lp_list" ></select>'
									+'</div>'
								+'</div>'
							);
			var $lp_chooseitems = $lp_controls.find('#lp_chooseitems');
			var $lp_chooseditems = $lp_controls.find('#lp_chooseditems');

			if( $lp_scope.options.height != 0)
			{
				$lp_controls.find('.lp_height').css({
					'height' : $lp_scope.options.height + 'px'
				});
			}
			else
			{
				var height = $lp_chooseitems.css('height');
				$lp_scope.options.height = height.substr(0,(height.length - 2));	
			}

			if($lp_scope.options.width != 0)
			{
				$lp_chooseitems.css({
					'width' : $lp_scope.options.width + 'px',
					'height': 'inherit'
				});
				$lp_chooseditems.css({
					'width' : $lp_scope.options.width + 'px',
					'height': 'inherit'
				});
			}
			var uniquearray = [];
		 	var temp;	
			$.each($lp_scope.options.optionlist,function(index, value)
			{
				if (typeof value != 'number')
					temp = value.toLowerCase();
				else
					temp = value.toString();

				if($.inArray(temp, uniquearray) === -1 && $.inArray(temp, $lp_scope.options.selectedlist) === -1 )
				{
					uniquearray.push(temp);
					$lp_chooseitems.append('<option value="' + value + '">' + value + '</option>');
				}
			});

			uniquearray = [];	
			$.each($lp_scope.options.selectedlist,function(index, value)
			{
				if (typeof value != 'number')
					temp = value.toLowerCase();
				else
					temp = value.toString();

				if($.inArray(temp, uniquearray) === -1)
				{
					$lp_controls.find('#lp_chooseitems option[value ="' + value + '"]').remove(); 
					uniquearray.push(temp);
					$lp_chooseditems.append('<option value="' + value + '">' + value + '</option>');
				}
			});

			$lp_scope.$element.append($lp_controls);

			$lp_controls.find("#lp_choose").on("click",function()
			{
				var selecteditem = $lp_chooseitems.val();
				if(selecteditem != null)
				{
					$.each(selecteditem, function(index,value){

						$lp_chooseditems.append('<option value="' + value + '">' + value + '</option>');
					});
					$lp_controls.find("#lp_chooseitems option:selected").remove();
				}
			});

			$lp_controls.find("#lp_unchoose").on("click", function()
			{
				var selecteditem = $lp_chooseditems.val();
				if(selecteditem != null)
				{
					$.each(selecteditem,function(index,value){
						$lp_chooseitems.append('<option value="' + value + '">' + value +	'</option>');
					});
					$lp_controls.find("#lp_chooseditems option:selected").remove();
				}
			});
		}
	}
}(jQuery));
